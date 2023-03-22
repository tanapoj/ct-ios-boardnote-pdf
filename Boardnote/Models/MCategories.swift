//
//  MCategories.swift
//  Boardnote
//
//  Created by Julapong on 3/6/18.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MCategories: CTModel {    
    var data: [MCategory]?
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        data    <- map["data"]
    }
}

enum MCategoryType: String {
    case meeting = "meeting"
    case news = "news"
    case documentPage = "document_page"
    case meetingArchive = "meeting_archive_month"
}

class MCategory: CTModel {
    var id: Int?
    var name: String?
    var slug: String?
    var term_group: Int?
    var term_taxonomy_id: Int?
    var taxonomy: String?
    var description: String?
    var parent: Int?
    var count: Int?
    var filter: String?
    var icon: String?
    var color: String?
    var type: String?
    var apiUrl: String?
    var children: [MCategory]?
    
    lazy var colorDisplay: UIColor = { [weak self] in
        guard let color = self?.color else { return Appearance.greyColor }
        return UIColor.colorFromHex(color) ?? Appearance.greenColor
    }()
    lazy var typeDisplay: String = { [weak self] in
        guard let type = self?.type else { return "" }
        var result = type.replacingOccurrences(of: "meetings", with: "meeting")
        result = result.replacingOccurrences(of: "document_pages", with: "document_page")
        return result
    }()
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        id                  <- map["term_id"]
        name                <- map["name"]
        slug                <- map["slug"]
        term_group          <- map["term_group"]
        term_taxonomy_id    <- map["term_taxonomy_id"]
        taxonomy            <- map["taxonomy"]
        description         <- map["description"]
        parent              <- map["parent"]
        count               <- map["count"]
        filter              <- map["filter"]
        icon                <- map["icon"]
        color               <- map["color"]
        type                <- map["type"]
        apiUrl              <- map["api_url"]
        children            <- map["children"]
    }
    
    // MARK: - Utility
}
