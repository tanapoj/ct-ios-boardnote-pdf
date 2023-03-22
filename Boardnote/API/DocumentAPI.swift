//
//  DocumentAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getDocument(categoryId: Int, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.document
        let request = service.resource(path)
            .withParam("categories", "\(categoryId)")
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.document(categoryId: categoryId)
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.meetings
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
    func cancelDocument() {
        self.cancel(APIPath.document)
    }
    
    func getDocument(meetingId: Int?, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let id = meetingId ?? 0
        let path = "\(APIPath.document)/\(id)"
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.document(meetingId: id)
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.meetingDetail
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
}
