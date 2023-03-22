//
//  MeetingAPI.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

extension AbstractAPI {
    // MARK: - Endpoint Accessors
    func getMeeting(categoryId: Int, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.meetings
        let request = service.resource(path)
            .withParam("categories", "\(categoryId)")
            .withParam("filter[orderby]", "meta_value")
            .withParam("filter[order]", "DESC")
            .withParam("filter[meta_key]", "meeting_time")
            .withParam("filter[meta_query][0][key]", "document_ready")
            .withParam("filter[meta_query][0][value]", "1")
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                //CLog(entity.jsonDict)
                let key = CacheKey.meetings(categoryId: categoryId)
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
    func getMeeting(meetingId: Int?, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let mid = meetingId ?? 0
        let path = "\(APIPath.meetings)/\(mid)"
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                CLog(entity.jsonDict)
                let key = CacheKey.meetings(meetingId: mid)
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
    func getMeeting(keyword: String?, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.meetings
        let request = service.resource(path)
            .withParam("filter[s]", keyword ?? "")
            .withParam("filter[orderby]", "meta_value")
            .withParam("filter[order]", "DESC")
            .withParam("filter[meta_key]", "meeting_time")
            .withParam("filter[meta_query][0][key]", "document_ready")
            .withParam("filter[meta_query][0][value]", "1")
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                //CLog(entity.jsonDict)
                let key = CacheKey.meetings(keyword: keyword ?? "")
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
    func cancelMeeting() {
        self.cancel(APIPath.meetings)
    }
    
    func getMeetingArchive(onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.meetingArchive
        let request = service.resource(path)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.meetingArchives
                let expiry = CacheExpiry.month
                let onMapping: onMapping = CacheMapping.meetingArchives
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
    func cancelMeetingArchive() {
        self.cancel(APIPath.meetingArchive)
    }
    
    func getMeetingDate(startDate: String, endDate: String, onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let path = APIPath.meetings
        let request = service.resource(path)
            .withParam("meeting_time_start", startDate)
            .withParam("meeting_time_end", endDate)
            .load()
            .onProgress({ (progress) in
                //ILog("onProgress: \(progress)")
            })
            .onSuccess({ [weak self] (entity) in
                let key = CacheKey.meetingsDate(startDate: startDate, endDate: endDate)
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
    
    func getMeetingCalendar(onSuccess: onSuccess?, onFailure: onFailure?, onCompletion: onCompletion?) {
        let startDate = Declaration.date.formatterAPI.string(from: Declaration.date.start)
        let endDate = Declaration.date.formatterAPI.string(from: Declaration.date.end)
        self.getMeetingDate(startDate: startDate,
                            endDate: endDate,
                            onSuccess: onSuccess,
                            onFailure: onFailure,
                            onCompletion: onCompletion)
    }
}
