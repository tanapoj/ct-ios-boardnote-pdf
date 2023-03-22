//
//  CTLog.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation

public func ILog(_ object: Any, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let time = formatter.string(from: Date())
    print("[\(time)] [\(className) \(functionName)] [#\(lineNumber)] \(object)")
    #endif
}

public func CLog(_ object: Any, fileName: String = #file, functionName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    print("\n----[\(className) \(functionName)] [#\(lineNumber)]----")
    print("\(object)")
    print("-----------------------------------------\n")
    #endif
}
