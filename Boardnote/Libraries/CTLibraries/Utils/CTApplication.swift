//
//  CTApplication.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation

open class Application: NSObject {
    public static var version : String {
        get {
            let value = "0.0"
            guard let dictionary = Bundle.main.infoDictionary else { return value }
            guard let result = dictionary["CFBundleShortVersionString"] as? String else { return value }
            return result
        }
    }
    public static var versionBuild : String {
        get {
            let value = "0.0"
            guard let dictionary = Bundle.main.infoDictionary else { return value }
            guard let result = dictionary["CFBundleVersion"] as? String else { return value }
            return result
        }
    }
    public static var versionDisplay: String {
        get {
            #if DEBUG
            return "\(Application.version) (\(Application.versionBuild))"
            #elseif TEST
            return "\(Application.version) (\(Application.versionBuild))"
            #else
            return "\(Application.version)"
            #endif
        }
    }
    public static var bundleName: String {
        get {
            let value = "com.centrillion.libraries"
            guard let dictionary = Bundle.main.infoDictionary else { return value }
            guard let result = dictionary["CFBundleIdentifier"] as? String else { return value }
            return result
        }
    }
    public static func isLatestVersion(_ latestVersion: String?) -> Bool {
        guard let latestVersion = latestVersion else { return false }
        let result: Bool = (Application.version.compare(latestVersion, options: .numeric, range: nil, locale: nil) != ComparisonResult.orderedAscending)
        return result
    }
}
