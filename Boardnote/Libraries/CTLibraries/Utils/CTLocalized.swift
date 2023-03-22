//
//  CTLocalized.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Localized.bundle, value: "", comment: "")
    }
    public func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Localized.bundle, value: "", comment: withComment)
    }
}

open class Localized {
    public enum Language: String {
        case base = "Base"
        case thai = "th"
        case english = "en"
    }
    private static let ofTypeResource = "lproj"
    private static let bundleID = Bundle.main.bundleIdentifier!
    private static let keyAppLanguage = [Localized.bundleID, ".appLanguage"].joined()
    
    private static var bundleSource: Bundle?
    public static var bundle: Bundle {
        var result = Localized.bundleSource
        if result == nil {
            result = Localized.getBundle()
            Localized.bundleSource = result
        }
        return result!
    }
    
    public static func setLocalized(_ languageCode: String?) {
        guard let code = languageCode else { return }
        ILog("setLocalized: \(code)")
        UserDefaults.standard.set(code, forKey: Localized.keyAppLanguage)
        UserDefaults.standard.synchronize()
        // update localized
        Localized.bundleSource = Localized.getBundle()
        Localized.updateLocalized()
    }
    
    public static func getLocalized() -> String {
        guard let result =  UserDefaults.standard.string(forKey: Localized.keyAppLanguage) else {
            // set a default, just in case
            let code = Locale.current.languageCode ?? Language.english.rawValue
            Localized.setLocalized(code)
            return code;
        }
        return result
    }
    
    public static func getBundle() -> Bundle {
        let type = Localized.ofTypeResource
        var path = Bundle.main.path(forResource: Localized.getLocalized(), ofType: type)
        if path == nil {
            path = Bundle.main.path(forResource: Language.english.rawValue, ofType: type)
        }
        //CLog(path)
        guard let pathResource = path else {
            return Bundle.main
        }
        var result = Bundle(path: pathResource)
        if result == nil {
            result = Bundle.main
        }
        return result!
    }
    
    // MARK: - Setup Localized
    public static func updateLocalized() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if let rootViewController = window.rootViewController {
            rootViewController.initLocalized()
        }
    }
}

public class LocalizedText {
    // MARK: Navigation
    public static var title_navigation_first: String       { return "title_navigation_first".localized }
    public static var title_navigation_second: String      { return "title_navigation_second".localized }
    public static var title_navigation_third: String       { return "title_navigation_third".localized }
    public static var title_navigation_fourth: String      { return "title_navigation_fourth".localized }
    public static var title_navigation_fifth: String       { return "title_navigation_fifth".localized }
    // MARK: Content
    public static var retry: String                        { return "retry".localized }
    // MARK: No data
    public static var no_data_retry_title: String          { return "no_data_retry_title".localized }
    public static var no_data_retry_subtitle: String       { return "no_data_retry_subtitle".localized }
    public static var data_not_found: String               { return "data_not_found".localized }
    
    // MARK: Sentence
    public static var sentence_error_prepare_data: String  { return "sentence_error_prepare_data".localized }
}
