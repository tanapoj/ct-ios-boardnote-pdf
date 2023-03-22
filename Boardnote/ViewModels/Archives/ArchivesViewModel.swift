//
//  ArchivesViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 11/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class ArchivesViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var enableLoadMore: Bool { return false }
    
    override init() {
        super.init()
    }
    
    override func onLocalLoad() {
        super.onLocalLoad()
        Cache.fetch(key: CacheKey.meetingArchives,
                    onMapping: CacheMapping.meetingArchives,
                    onSuccess: onLocalSuccess,
                    onCompletion: onLocalCompletion)
    }
    
    override func onServerLoad() {
        super.onServerLoad()
        API.getMeetingArchive(onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
    }
    
    override func onServerCancel() {
        API.cancelMeetingArchive()
    }
}
