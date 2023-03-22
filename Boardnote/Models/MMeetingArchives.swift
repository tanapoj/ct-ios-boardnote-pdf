//
//  MMeetingArchives.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 17/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MMeetingArchives: CTModel {
    var status: String?
    var data: [MMeetingArchive]?
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        status  <- map["status"]
        data    <- map["data"]
    }
    
    // MARK: - Utility
}

class MMeetingArchive: CTModel {
    var title: String?
    var type: String?
    var startDate: String?
    var endDate: String?
    var apiUrl: String?
    
    var query: String {
        guard let startDate = self.startDate, let endDate = self.endDate else { return "" }
        return "?meeting_time_start=\(startDate)&meeting_time_end=\(endDate)"
    }
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        title       <- map["title"]
        type        <- map["type"]
        startDate   <- map["start_date"]
        endDate     <- map["end_date"]
        apiUrl      <- map["api_url"]
    }
}
