//
//  CTModel.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 31/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation

open class CTModel: Mappable {    
    // MARK: - Initialization Method
    required public init?(map: Map){ }
    
    open func mapping(map: Map) { }
    
    open var debugDescription:String {
        return Mapper().toJSONString(self, prettyPrint: true) ?? ""
    }
}
