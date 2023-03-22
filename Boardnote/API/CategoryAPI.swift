//
//  CategoryAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 27/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getCategory(onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.category
        let request = service.resource(path)
            .withParam("hide_empty", "0")
            .withParam("exclude", "1")
            .loadIfNeeded()?
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.category
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.categories
                self?.onSuccess(json: entity.jsonDict, key: key, expiry: expiry, onMapping: onMapping, onSuccess: onSuccess, onFailure: onFailure)
            })
            .onFailure({ [weak self] (error) in
                self?.onFailure(onFailure, error: error)
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(onCompletion, path: path)
            })
        self.didLoadCompletion(onCompletion, request: request, path: path)
    }
    func cancelCategory() {
        self.cancel(APIPath.category)
    }
}
