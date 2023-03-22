//
//  CTCacheExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 13/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

struct CacheKey {
    static let pdfSettings = "pdf_settings"
    static let user = "user"
    static let latestUser = "latest_user"
    static let category = "category"
    static func meetings(categoryId: Int) -> String { return "meetings_\(categoryId)" }
    static func meetings(meetingId: Int) -> String { return "meetings_id_\(meetingId)" }
    static func meetings(keyword: String) -> String { return "meetings_keyword_\(keyword)" }
    static func meetingsDate(startDate: String, endDate: String) -> String { return "meetings_date_\(startDate)_\(endDate)" }
    static let meetingArchives = "meeting_archives"
    static let news = "news"
    static func news(meetingId: Int) -> String { return "news_id_\(meetingId)" }
    static func document(categoryId: Int) -> String { return "document_\(categoryId)" }
    static func document(meetingId: Int) -> String { return "document_id_\(meetingId)" }
    static func attendances(meetingId: Int) -> String { return "attendances_\(meetingId)" }
    static func meAttendances(meetingId: Int) -> String { return "attendances_\(meetingId)_me" }
}

struct CacheMapping {
    static let user: Cache.onMapping = { (json) -> Any? in
        let result = MUser(JSON: json)
        return result
    }
    static let categories: Cache.onMapping = { (json) -> Any? in
        let result = MCategories(JSON: json)
        return result?.data
    }
    static let meetings: Cache.onMapping = { (json) -> Any? in
        let result = MMeetings(JSON: json)
        return result?.data
    }
    static let meetingDetail: Cache.onMapping = { (json) -> Any? in
        let data: [String:Any] = json["data"] as? [String:Any] ?? [:]
        let result = MMeeting(JSON: data)
        return result
    }
    static let meetingArchives: Cache.onMapping = { (json) -> Any? in
        let result = MMeetingArchives(JSON: json)
        return result?.data
    }
    static let attendances: Cache.onMapping = { (json) -> Any? in
        let result = MAttendances(JSON: json)
        return result?.data
    }
}

extension Cache {
    static func setup() {
        Cache.configure(version: "1.0") // change to reset cache
        Cache.clearExpiredData()
        Cache.clearExpiredImage()
    }
    
    static func saveLatestUser() {
        guard let user = Instance.latestUser else { return }
        let kLatestUser = CacheKey.latestUser
        Cache.save(key: kLatestUser, object: [kLatestUser:user])
    }
    
    static func fetchLatestUser(onSuccess: ((_ result: String) -> Void)? = nil, onCompletion: Cache.onCompletion? = nil) {
        Cache.fetch(key: CacheKey.latestUser, onMapping: nil, onSuccess: { (result) in
            if let data = result as? [String:Any], let latestUser = data[CacheKey.latestUser] as? String {
                onSuccess?(latestUser)
            }
        }, onCompletion: {
            onCompletion?()
        })
    }
    
    static func clearAllImageAndData(onCompletion: Cache.onCompletion? = nil) {
        Cache.clearAllImage(onCompletion: {
            Cache.clearAllData(onCompletion: {
                DispatchQueue.main.async(execute: {
                    Instance.user = nil
                    Cache.saveLatestUser()
                    onCompletion?()
                })
            })
        })
    }
}
