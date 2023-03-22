//
//  PushAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 17/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    @discardableResult func saveToken(_ deviceToken: String, userId: String?, onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.saveToken
        let request = service.resource(path)
            .withParam("auth_key", "cXWBlCWWOEIf9A7")
            .withParam("device_token", deviceToken)
            .withParam("device_type", "ios")
            .withParam("user_id", userId ?? "-1")
            .request(.post)
            .onSuccess({ (entity) in
                CLog(entity.jsonDict)
                onSuccess?()
            })
            .onFailure({ (error) in
                CLog(error.jsonDict)
                onSuccess?()
                /* Fixed for api save success but return error code 404
                let result = MError.create(error: error)
                if result.message == "Token saved successfully" { // api save success but return error code 404
                    onSuccess?()
                }
                else {
                    onFailure?(result, CTAPIStatus.failure)
                }*/
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(nil, path: path)
            })
        return request
    }
}
