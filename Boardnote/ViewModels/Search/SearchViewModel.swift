//
//  SearchViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 24/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class SearchViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var enableLoadMore: Bool { return false }
    
    override init() {
        super.init()
    }
    
    override func onLocalLoad() {
        
    }
    
    override func onServerLoad() {

    }
    
    override func onServerCancel() {
        API.cancelMeeting()
    }
    
    func search(keyword: String?) {
        super.onServerLoad()
        API.getMeeting(keyword: keyword, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
    }
}
