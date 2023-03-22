//
//  MProfiles.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 20/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MProfiles: CTModel {
    var items: [MProfile]?
    
    // MARK: - Mapping
    open override func mapping(map: Map) {
        items <- map["items"]
    }
}

class MProfile: CTModel {
    var title: String?
    var imageName: String?
    var imageWidth: CGFloat?
    var heightForRow: CGFloat?
    var isHeader: Bool?
    var isSelect: Bool?
    var color: UIColor?
    
    // MARK: - Mapping
    open override func mapping(map: Map) {
        title           <- map["title"]
        imageName       <- map["imageName"]
        imageWidth      <- map["imageWidth"]
        heightForRow    <- map["heightForRow"]
        isHeader        <- map["isHeader"]
        isSelect        <- map["isSelect"]
        color           <- map["color"]
    }
}
