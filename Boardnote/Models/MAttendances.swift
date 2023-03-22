//
//  MAttendances.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 13/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MAttendances: CTModel {
    var data: [MUser]?

    // MARK: - Mapping
    open override func mapping(map: Map) {
        data <- map["data"]
    }
}
