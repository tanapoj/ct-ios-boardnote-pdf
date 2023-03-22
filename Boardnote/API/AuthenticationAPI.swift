//
//  AuthenticationAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 29/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    @discardableResult func login(_ username: String, _ password: String, onSuccess: @escaping () -> Void, onFailure: @escaping onFailure) -> Request {
        // set latest_user
        Instance.latestUser = username
        // server
        let path = APIPath.login
        let key = CacheKey.user
        let onMapping: onMapping = CacheMapping.user
        let request = service.resource(path)
            .request(.post, json: ["username": username, "password": password])
            .onSuccess({ (entity) in
                let json = entity.jsonDict
                guard let user = onMapping(json) as? MUser else {
                    onFailure(CTAPIErrorEnvelope.parsingJSON, CTAPIStatus.failure)
                    return
                }
                guard let _ = user.token else {
                    onFailure(CTAPIErrorEnvelope.tokenMissing, CTAPIStatus.failure)
                    return
                }
                CLog(user.debugDescription)
                // save in database
                Cache.save(key: key, object: json)
                // set user
                Instance.user = user
                // save latest_user
                Cache.saveLatestUser()
                //
                onSuccess()
            })
            .onFailure({ (error) in
                CLog(error.jsonDict)
                onFailure(MError.create(error: error), CTAPIStatus.failure)
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(nil, path: path)
                // save token
                if let token = Instance.deviceToken {
                    DispatchQueue.main.async(execute: {
                        API.saveToken(token, userId: Instance.user?.id)
                    })
                }
            })
        return request
    }
    
    @discardableResult func validateToken(onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.validateToken
        let request = service.resource(path)
            .request(.post)
            .onSuccess({ (entity) in
                CLog(entity.jsonDict)
                onSuccess?()
            })
            .onFailure({ (error) in
                CLog(error.jsonDict)
                Cache.clearAllImageAndData(onCompletion: {
                    onFailure?(MError.create(error: error), CTAPIStatus.failure)
                })
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(nil, path: path)
            })
        return request
    }
    
    @discardableResult func logOut(onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.logout
        let request = service.resource(path)
            .request(.post)
            .onSuccess({ (entity) in
                CLog(entity.jsonDict)
                onSuccess?()
            })
            .onFailure({ (error) in
                CLog(error.jsonDict)
                onFailure?(MError.create(error: error), CTAPIStatus.failure)
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(nil, path: path)
            })
        return request
    }
}
