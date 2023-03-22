//
//  MStaticData.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MStaticData {
    var tabBars: [MStaticDataRow] = []
    
    // MARK: - Shared Instance
    static let shared = MStaticData()
    
    // MARK: - Initialization Method
    private init() { }
    
}

class MStaticDataRow: Mappable {
    var title: String?
    var imageName: String?
    var selectedImageName: String?
    
    var titleLocalized: String? {
        guard let title = self.title else { return nil }
        return title.localized
    }
    var image: UIImage? {
        guard let name = self.imageName else { return nil }
        return UIImage(named: name)
    }
    var selectedImage: UIImage? {
        guard let name = self.selectedImageName else { return nil }
        return UIImage(named: name)
    }
    
    // MARK: - Initialization Method
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        title               <- map["title"]
        imageName           <- map["imageName"]
        selectedImageName   <- map["selectedImageName"]
    }
    
    // MARK: - Utility
    static func create(_ source: Dictionary<String,Any>?) -> [MStaticDataRow] {
        var dataSource: [MStaticDataRow] = []
        guard let items = source?["data"] as? NSArray else { return dataSource }
        items.forEach { (result) in
            let value = result as! Dictionary<String,Any>
            let item = MStaticDataRow(JSON: value)!
            dataSource.append(item)
        }
        return dataSource
    }
}
