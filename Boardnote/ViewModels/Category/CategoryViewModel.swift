//
//  CategoryViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class CategoryViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var enableLoadMore: Bool { return false }
    var categories: [MCategory]?
    
    override init() {
        super.init()
    }
    init(categories: [MCategory]?) {
        super.init()
        self.categories = categories
    }
    
    override func onLocalLoad() {
        if let categories = categories, categories.count > 0 {
            onLocalSuccess?(categories)
        }
        else {
            super.onLocalLoad()
            Cache.fetch(key: CacheKey.category,
                        onMapping: CacheMapping.categories,
                        onSuccess: onLocalSuccess,
                        onCompletion: onLocalCompletion)
        }
    }
    
    override func onServerLoad() {
        if let categories = categories, categories.count > 0 { return }
        super.onServerLoad()
        API.getCategory(onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
    }
    
    override func onServerCancel() {
        if let categories = categories, categories.count > 0 { return }
        API.cancelCategory()
    }
}
