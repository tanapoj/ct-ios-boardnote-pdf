//
//  InstanceHelper.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import JWTDecode

class Instance {
    static var user: MUser? {
        didSet {
            DispatchQueue.main.async {
                CLog(user?.token ?? "")
                API.authToken = user?.token
            }
        }
    }
    static var deviceToken: String?
    static var latestVersion: String?
    static var latestUser: String?
    
    // MARK: - Prepare Data
    static func prepareData(_ completion: ((_ completed: Bool) -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()
        var result = false
        
        // fetch pdf_settings
        dispatchGroup.enter()
        DispatchQueue.global().async {
            ILog("fetch pdf_settings - loading")
            Cache.fetch(key: CacheKey.pdfSettings, onMapping: nil, onSuccess: { (result) in
                ILog("fetch pdf_settings - \(result ?? [:])")
                PDF.shared.settings = PDFSettings.mapping(result as? [String:Any])
            }, onCompletion: {
                ILog("fetch pdf_settings - complete")
                dispatchGroup.leave()
            })
        }
        
        // fetch latest_user
        dispatchGroup.enter()
        DispatchQueue.global().async {
            ILog("fetch latest_user - loading")
            Cache.fetchLatestUser(onSuccess: { (result) in
                ILog("fetch latest_user - \(result)")
                Instance.latestUser = result
            }, onCompletion: {
                ILog("fetch latest_user - complete")
                dispatchGroup.leave()
            })
        }
        
        // fetch user
        dispatchGroup.enter()
        DispatchQueue.global().async {
            ILog("fetch user - loading")
            Cache.fetch(key: CacheKey.user, onMapping: CacheMapping.user, onSuccess: { (result) in
                if let user = result as? MUser {
                    CLog(user.debugDescription)
                    Instance.user = user
                }
            }, onCompletion: {
                ILog("fetch user - complete")
                result = true
                dispatchGroup.leave()
            })
        }
        
        // completion
        dispatchGroup.notify(queue: DispatchQueue.main) {
            ILog("prepareData - complete")
            if let completion = completion {
                completion(result)
            }
        }
    }
    
    // MARK: - Check version
    static func checkVersion() {
        API.getVersion(onSuccess: { (version) in
            Instance.latestVersion = version
            if Application.isLatestVersion(version) == false {
                alertVersion()
            }
        }, onFailure: {
            alertVersion()
        })
    }
    
    private static func alertVersion() {
        DispatchQueue.main.async(execute: {
            Alert.latestVersion()
        })
    }
}
