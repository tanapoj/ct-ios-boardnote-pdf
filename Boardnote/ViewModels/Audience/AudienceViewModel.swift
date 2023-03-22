//
//  AudienceViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class AudienceViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var enableLoadMore: Bool { return false }
    var meetingId: Int!
    
    override init() {
        super.init()
    }
    init(meetingId: Int?) {
        super.init()
        self.meetingId = meetingId ?? 0
    }
    
    override func onLocalLoad() {
        super.onLocalLoad()
        Cache.fetch(key: CacheKey.attendances(meetingId: meetingId),
                    onMapping: CacheMapping.attendances,
                    onSuccess: onLocalSuccess,
                    onCompletion: onLocalCompletion)
    }
    
    override func onServerLoad() {
        super.onServerLoad()
        API.getAttendances(meetingId: meetingId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
    }
    
    override func onServerCancel() {
        API.cancelAttendances()
    }
}
