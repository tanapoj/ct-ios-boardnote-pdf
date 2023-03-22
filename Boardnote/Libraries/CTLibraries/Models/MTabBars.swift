//
//  MTabBars.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

open class MTabBars: CTModel {
    public var title: String?
    public var imageName: String?
    public var selectedImageName: String?
    
    public var titleLocalized: String? {
        guard let title = self.title else { return nil }
        return title.localized
    }
    public var image: UIImage? {
        guard let name = self.imageName else { return nil }
        return UIImage(named: name)
    }
    public var selectedImage: UIImage? {
        guard let name = self.selectedImageName else { return nil }
        return UIImage(named: name)
    }
    
    // MARK: - Mapping
    open override func mapping(map: Map) {
        title               <- map["title"]
        imageName           <- map["imageName"]
        selectedImageName   <- map["selectedImageName"]
    }
    
    // MARK: - Utility
    public static func create(_ source: [[String:Any]]?) -> [MTabBars] {
        var dataSource: [MTabBars] = []
        guard let items = source else { return dataSource }
        items.forEach { (result) in
            let item = MTabBars(JSON: result)!
            dataSource.append(item)
        }
        return dataSource
    }
}
