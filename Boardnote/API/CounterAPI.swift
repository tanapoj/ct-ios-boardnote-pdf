//
//  CounterAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 25/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    @discardableResult func counterMeeting(_ meetingId: Int, onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.counterMeeting
        let request = service.resource(path)
            .request(.post, json: ["id": "\(meetingId)"])
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
    @discardableResult func counterFileDownload(_ meetingId: Int?, filename: String, onSuccess: (() -> Void)? = nil, onFailure: onFailure? = nil) -> Request {
        let path = APIPath.counterFileDownload
        //let param = ["meetingID": "\(meetingId ?? 0)", "filename": filename] // change to fileID
        let fileID = "\(meetingId ?? 0)-\(filename)".toBase64()
        let param = ["fileID": fileID]
        CLog(param)
        let request = service.resource(path)
            .request(.post, urlEncoded: param)
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
