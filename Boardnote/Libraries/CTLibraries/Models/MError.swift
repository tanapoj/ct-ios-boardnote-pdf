//
//  MError.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 31/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

open class MError: NSObject {
    public var code: String?
    public var message: String?
    public var requestError: RequestError?
    
    open class var mapping: (([String : Any]) -> MError) {
        return { (json) in
            let result = MError()
            result.code = json["code"] as? String
            result.message = json["message"] as? String
            return result
        }
    }
    
    public override init() {
        
    }

    public static func create(JSON: [String : Any], mapping: (([String : Any]) -> MError)? = nil) -> MError {
        var result: MError = MError()
        if let mapping = mapping {
            result = mapping(JSON)
        }
        else {
            result = MError.mapping(JSON)
        }
        return result
    }
    
    public static func create(error: RequestError, mapping: (([String : Any]) -> MError)? = nil) -> MError {
        let result = MError.create(JSON: error.jsonDict, mapping: mapping)
        result.requestError = error
        return result
    }
}
