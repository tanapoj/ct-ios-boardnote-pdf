//
//  CTAPI.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 24/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

@objc public enum CTAPIStatus: Int {
    case success, failure, cancel, dataNotFound
}

public struct CTAPIErrorEnvelope {
    public static let parsingJSON = MError.create(JSON: ["code":"[internal] json_parsing_error", "message":"JSON parsing error"])
}

open class CTAPI: NSObject {
    public enum Log {
        case all, detailed, common
    }
    
    // MARK: - Handler
    public typealias onProgress = (_ progress: Double) -> Void
    public typealias onMapping = (_ json: [String:Any]) -> Any?
    public typealias onSuccess = (_ result: Any?, _ status: CTAPIStatus) -> Void
    public typealias onFailure = (_ error: MError, _ status: CTAPIStatus) -> Void
    public typealias onCompletion = () -> Void
    
    // MARK: - Configuration
    open var service: Service!
    open var baseUrl: String { return "" }
    open var version: String { return "" }
    open var expirationTime: TimeInterval { return 37.0 }
    open var log: Log? {
        didSet {
            #if DEBUG
            switch log {
            case .all?:         SiestaLog.Category.enabled = .all
            case .detailed?:    SiestaLog.Category.enabled = .detailed
            case .common?:      SiestaLog.Category.enabled = .common
            case .none:         SiestaLog.Category.enabled = .common
            }
            #endif
        }
    }
    open var standardTransformers: [StandardTransformer] { return [.json, .text, .image] }
    open var isCertificatePinningEnabled: Bool { return false  }
    open var certificatePinningPath: Array<String?> { return []}
    public var request: Request?
    public var requests: [String: Request?] = [:]
    
    // MARK: - Authentication
    open var authToken: String? {
        didSet {
            service.invalidateConfiguration()  // So that future requests for existing resources pick up config change
            service.wipeResources()            // Scrub all unauthenticated data
        }
    }
    open var isAuthenticated: Bool {
        return authToken != nil
    }
    open func logOut() {
        authToken = nil
    }
    
    // MARK: - init
    public override init() {
        super.init()
        initialize()
    }
    public func initialize() {
        if isCertificatePinningEnabled == true {
            let networking = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
            service =  Service(baseURL: "\(baseUrl)\(version)", standardTransformers: standardTransformers, networking: networking)
        }
        else {
            service = Service(baseURL: "\(baseUrl)\(version)", standardTransformers: standardTransformers)
        }
        #if DEBUG
        SiestaLog.Category.enabled = .detailed
        #endif
        // –––––– Global configuration ––––––
        configure()
        configureTransformer()
    }
    
    // MARK: - configuration & mapping
    open func configure() {
        service.configure {
            // Authentication
            if let authToken = self.authToken {
                $0.headers["Authorization"] = "Bearer \(authToken)"
            }
            // timeout
            $0.expirationTime = self.expirationTime
        }
    }
    open func configureTransformer() {
        
    }
    
    // MARK: - Cancel
    open func cancel(_ path: String) {
        if let request: Request = requests[path] as? Request {
            request.cancel()
            requests.removeValue(forKey: path)
        }
    }
    
    // MARK: - Helper
    open func onSuccess(json: [String:Any], key: String, expiry: CacheExpiry, onMapping: onMapping, onSuccess: onSuccess?, onFailure: onFailure?) {
        var result: Any?
        var status: CTAPIStatus?
        if let obj = onMapping(json) as? [Any] {
            status = (obj.count > 0) ? .success : .dataNotFound
            result = obj
        }
        else if let obj = onMapping(json) {
            status = .success
            result = obj
        }
        else {
            status = .failure
        }
        
        if status == .success || status == .dataNotFound {
            // save in database
            Cache.save(key: key, object: json, expiry: expiry.rawValue, onSuccess: nil, onCompletion: nil)
            onSuccess?(result, status!)
        }
        else {
            onFailure?(CTAPIErrorEnvelope.parsingJSON, status!)
        }
        
    }
    open func onFailure(_ onFailure: onFailure?, error: RequestError) {
        CLog("onFailure: \(error)")
        if error.cause is RequestError.Cause.RequestCancelled {
            ILog("cancel")
        }
        else {
            onFailure?(MError.create(error: error), CTAPIStatus.failure)
        }
    }
    open func onCompletion(_ onCompletion: onCompletion?, path: String) {
        self.requests.removeValue(forKey: path)
        onCompletion?()
    }
    open func didLoadCompletion(_ onCompletion: onCompletion?, request: Request?, path: String) {
        if let _ = request {
            self.requests[path] = request
        }
        else { // is up to date
            onCompletion?()
        }
    }
    
    // MARK: - Endpoint Accessors
    public func ping() -> Resource {
        return service.resource("/ping")
    }
}

extension CTAPI: URLSessionDelegate {
    open func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    open func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let serverTrust = challenge.protectionSpace.serverTrust
        let certificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        if isCertificatePinningEnabled == false {
            let credential:URLCredential = URLCredential(trust: serverTrust!)
            completionHandler(.useCredential, credential)
        }
        else {
            // Set SSL policies for domain name check
            let policies = NSMutableArray();
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
            SecTrustSetPolicies(serverTrust!, policies);
            
            // Evaluate server certificate
            var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
            SecTrustEvaluate(serverTrust!, &result)
            let isServerTrusted:Bool = result == SecTrustResultType.unspecified || result ==  SecTrustResultType.proceed
            
            // Get local and remote cert data
            let remoteCertificateData:NSData = SecCertificateCopyData(certificate!)
            let pathToCerts = certificatePinningPath
            let isAllServerTrusted = pathToCerts.contains { pathToCert in
                let localCertificate:NSData = NSData(contentsOfFile: pathToCert!)!
                return !remoteCertificateData.isEqual(to: localCertificate as Data)
            }
            
            if (isServerTrusted && isAllServerTrusted) {
                let credential:URLCredential = URLCredential(trust: serverTrust!)
                completionHandler(.useCredential, credential)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                DispatchQueue.main.async(execute: onCertificatePinningFailure)
            }
            
        }
    }
    open func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
    
    @objc open func onCertificatePinningFailure() {
        CLog("onCertificatePinningFailure: Not implement !!!!!")
    }
}
