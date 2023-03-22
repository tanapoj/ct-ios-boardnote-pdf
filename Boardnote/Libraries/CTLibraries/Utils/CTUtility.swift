//
//  CTUtility.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

open class Utility {
    // MARK: - class
    public static func nameOfClass(_ object: AnyObject) -> String {
        return String(describing: type(of: object))
        //let nameClass = object.description.components(separatedBy: ".").last!.components(separatedBy: ":").first!
        //return nameClass
    }
    
    // MARK: - call back & main
    public static func callback(_ seconds: Double, _ completion: @escaping () -> Swift.Void) {
        let duration = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: duration) {
            completion()
        }
    }
    public static func performMain(_ completion: @escaping () -> Swift.Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
    public static func thread(background: (() -> Void)? = nil, main: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            if let background = background { background() }
            DispatchQueue.main.async {
                if let main = main { main() }
            }
        }
    }
    
    // MARK: - File json
    public static func dictionaryOfFileJson(_ withFileName: String) -> Dictionary<String, Any>? {
        do {
            if let file = Bundle.main.url(forResource: withFileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    return object
                } else if json is [Any] {
                    CLog("dictionaryJson: JSON is an array")
                    return nil
                } else {
                    CLog("dictionaryJson: JSON is invalid")
                    return nil
                }
            } else {
                CLog("dictionaryJson: no file")
                return nil
            }
        } catch {
            CLog("dictionaryJson: \(error.localizedDescription)")
            return nil
        }
    }
}
