//
//  AttendancesAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 12/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getAttendances(meetingId: Int, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = "\(APIPath.attendances)/\(meetingId)"
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                //CLog(entity.jsonDict)
                let key = CacheKey.attendances(meetingId: meetingId)
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.attendances
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
    func cancelAttendances() {
        self.cancel(APIPath.attendances)
    }
    
    func meAttendances(meetingId: Int, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = "\(APIPath.attendances)/\(meetingId)/me"
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                //CLog(entity.jsonDict)
                let json: [String:Any] = entity.jsonDict["data"] as? [String : Any] ?? [:]
                let key = CacheKey.meAttendances(meetingId: meetingId)
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.user
                self?.onSuccess(json: json, key: key, expiry: expiry, onMapping: onMapping, onSuccess: onSuccess, onFailure: onFailure)
            })
            .onFailure({ [weak self] (error) in
                self?.onFailure(onFailure, error: error)
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(onCompletion, path: path)
            })
        self.didLoadCompletion(onCompletion, request: request, path: path)
    }
    
    @discardableResult func postAttendances(_ meetingId: Int, onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.attendances
        let request = service.resource(path)
            .request(.post, urlEncoded: ["meetingID": "\(meetingId)"])
            .onSuccess({ (entity) in
                onSuccess?()
            })
            .onFailure({ (error) in
                onFailure?(MError.create(error: error), CTAPIStatus.failure)
            })
            .onCompletion({ [weak self] (respone) in
                self?.onCompletion(nil, path: path)
            })
        return request
    }
}
