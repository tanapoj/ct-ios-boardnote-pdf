//
//  AbstractAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 27/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta
import Alamofire

extension CTAPIErrorEnvelope {
    static let tokenMissing = MError.create(JSON: ["code":"[internal] JWT_token_missing", "message":"JWT token missing"])
    static let searchMissing = MError.create(JSON: ["code":"[internal] search_keyword_missing", "message":"Search keyword missing"])
}

struct APIPath {
    static let forgotPassword       = "/wp-login.php?action=lostpassword"
    static let login                = "/wp-json/jwt-auth/v1/token"
    static let logout               = "/wp-json/jwt-auth/v1/logout"
    static let validateToken        = "/wp-json/jwt-auth/v1/token/validate"
    static let category             = "/wp-json/wp/v2/taxonomy/category"
    static let meetings             = "/wp-json/wp/v2/meetings"
    static let meetingArchive       = "/wp-json/wp/v2/meeting-archive"
    static let news                 = "/wp-json/wp/v2/news"
    static let document             = "/wp-json/wp/v2/document-pages"
    static let attendances          = "/wp-json/wp/v2/attendances"
    static let saveToken            = "/push/savetoken"
    static let counterMeeting       = "/wp-json/post-views-counter/view-post"
    static let counterFileDownload  = "/wp-json/wp/v2/file_downloads"
    static let version              = "/wp-json/wp/v2/get_app_version"
}

public enum APIEnvironment {
    case dev, test, prod
}

// MARK: - API
let API: AbstractAPI = AbstractAPI()
class AbstractAPI: CTAPI {
    static let environment: APIEnvironment = .prod
    static let defaultUrl: String = (AbstractAPI.environment == .dev) ? "https://baac-mdinote.centrilliontech.io" : "https://mdinote.baac.or.th"
    static let defaultIntUrl: String = (AbstractAPI.environment == .dev) ? "https://baac-mdinote.centrilliontech.io" : "https://mdinote.int.baac.or.th"
    static var baseUrl: String?

    // MARK: - Configuration
    override var expirationTime: TimeInterval { return 30.0 }
    override var baseUrl: String {
        guard let baseUrl = AbstractAPI.baseUrl else { return AbstractAPI.defaultUrl }
        return baseUrl
    }
    override var version: String { return "" }
    override var isCertificatePinningEnabled: Bool { return true  }
    override var certificatePinningPath: Array<String?> {
        //let name = (AbstractAPI.environment == .dev) ? "baac-mdinote_centrilliontechio" : "star_baac_or_th"
        (AbstractAPI.environment == .dev) ?
            [Bundle.main.path(forResource: "baac-mdinote_centrilliontechio", ofType: "cer")] :
          [
            Bundle.main.path(forResource: "mdinote", ofType: "cer"),
            Bundle.main.path(forResource: "2022-06-13_mdinote", ofType: "crt"),
          ]
    }
    var downloadAppPath: String { return "\(baseUrl)" }
    var forgotPasswordPath: String { return "\(baseUrl)\(APIPath.forgotPassword)" }
    var downloadRequest: DownloadRequest?
    
    // MARK: - configuration & mapping
    override func configure() {
        super.configure()
    }
    override func configureTransformer() {
        super.configureTransformer()
    }
    
    // MARK: - Helper
    override func onFailure(_ onFailure: onFailure?, error: RequestError) {
        CLog("onFailure: \(error)")
        if error.cause is RequestError.Cause.RequestCancelled {
            ILog("cancel")
        }
        else {
            if error.httpStatusCode == 403 { // valid token
                Cache.clearAllImageAndData(onCompletion: {
                    Alert.errorValidateToken()
                })
            }
            else {
                onFailure?(MError.create(error: error), CTAPIStatus.failure)
            }
        }
    }
    
    // MARK: - Download
    func download(urlString: String, fileName: String, meetingId: Int?, onSuccess: ((_ url: URL) -> Void)? = nil, onFailure: ((_ error: Error?) -> Void)? = nil) {
        var headers: HTTPHeaders = [:]
        if let authToken = self.authToken {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let directoryURL = PDF.shared.directoryURL
            let fileURL = directoryURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        downloadRequest = Alamofire.download(urlString, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers, to: destination).downloadProgress(closure: { (progress) in
            ILog("Download Progress: \(progress.fractionCompleted)")
        }).response(completionHandler: { (response) in
            if response.error == nil, let url = response.destinationURL {
                CLog("destinationURL: \(url)")
                onSuccess?(url)
            }
            else {
                CLog("response: \(String(describing: response.error))")
                onFailure?(response.error)
            }
        })
        API.counterFileDownload(meetingId, filename: fileName)
    }
    
    func validURL(onCompletion: (() -> Void)? = nil) {
        let baseURL = AbstractAPI.defaultIntUrl
        let networking = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        let service: Service = Service(baseURL: baseURL, standardTransformers: standardTransformers, networking: networking)
        service.resource("")
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ (entity) in
                AbstractAPI.baseUrl = AbstractAPI.defaultIntUrl
            })
            .onFailure({ (error) in
                AbstractAPI.baseUrl = AbstractAPI.defaultUrl
            })
            .onCompletion({ [weak self] (respone) in
                self?.initialize()
                onCompletion?()
            })
    }
}

extension AbstractAPI {
    @objc override func onCertificatePinningFailure() {
        guard let _ = AbstractAPI.baseUrl else { return }
        Cache.clearAllImageAndData(onCompletion: {
            Alert.errorCertificatePinning()
        })
    }
}
