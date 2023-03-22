//
//  NewsAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getNews(onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.news
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.news
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
    func cancelNews() {
        self.cancel(APIPath.news)
    }
    
    func getNews(meetingId: Int?, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let id = meetingId ?? 0
        let path = "\(APIPath.news)/\(id)"
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.news(meetingId: id)
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
