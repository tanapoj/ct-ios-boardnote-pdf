//
//  CalendarViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 11/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class CalendarViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    let startDate = Declaration.date.formatterAPI.string(from: Declaration.date.start)
    let endDate = Declaration.date.formatterAPI.string(from: Declaration.date.end)
    
    override init() {
        super.init()
        resource = "" // fixed hide Caution onServerCompletion
    }
    
    override func onLocalLoad() {
        super.onLocalLoad()
        Cache.fetch(key: CacheKey.meetingsDate(startDate: startDate, endDate: endDate),
                    onMapping: CacheMapping.meetings,
                    onSuccess: onLocalSuccess,
                    onCompletion: onLocalCompletion)
    }
    
    override func onServerLoad() {
        super.onServerLoad()
        API.getMeetingDate(startDate: startDate, endDate: endDate, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
    }
    
    override func onServerCancel() {
        API.cancelMeeting()
    }
}
