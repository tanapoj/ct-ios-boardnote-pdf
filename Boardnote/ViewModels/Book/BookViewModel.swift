//
//  BookViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class BookViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    var type: MCategoryType!
    var category: MCategory?
    var meetingArchive: MMeetingArchive?
    
    override init() {
        super.init()
    }
    init(type: MCategoryType, category: MCategory?, meetingArchive: MMeetingArchive?) {
        super.init()
        self.type = type
        self.category = category
        self.meetingArchive = meetingArchive
    }
    
    override func onLocalLoad() {
        super.onLocalLoad()
        let categoryId = self.category?.id ?? 0
        var key = ""
        if self.type == .meeting {
            key = CacheKey.meetings(categoryId: categoryId)
        }
        else if self.type == .news {
            key = CacheKey.news
        }
        else if self.type == .meetingArchive {
            let startDate = self.meetingArchive?.startDate ?? ""
            let endDate = self.meetingArchive?.endDate ?? ""
            key = CacheKey.meetingsDate(startDate: startDate, endDate: endDate)
        }
        else if self.type == .documentPage {
            key = CacheKey.document(categoryId: categoryId)
        }
        Cache.fetch(key: key, onMapping: CacheMapping.meetings, onSuccess: onLocalSuccess, onCompletion: onLocalCompletion)
    }
    
    override func onServerLoad() {
        super.onServerLoad()
        let categoryId = self.category?.id ?? 0
        if self.type == .meeting {
            API.getMeeting(categoryId: categoryId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
        else if self.type == .news {
            API.getNews(onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
        else if self.type == .meetingArchive {
            let startDate = self.meetingArchive?.startDate ?? ""
            let endDate = self.meetingArchive?.endDate ?? ""
            API.getMeetingDate(startDate: startDate, endDate: endDate, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
        else if self.type == .documentPage {
            API.getDocument(categoryId: categoryId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
    }
    
    override func onServerCancel() {
        if self.type == .meeting {
            API.cancelMeeting()
        }
        else if self.type == .news {
            API.cancelNews()
        }
        else if self.type == .meetingArchive {
            API.cancelMeetingArchive()
        }
        else if self.type == .documentPage {
            API.cancelDocument()
        }
    }
    
}
