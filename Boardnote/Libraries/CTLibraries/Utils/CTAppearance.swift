//
//  CTAppearance.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class AppearanceConfigure: NSObject {
    public var primaryColor: UIColor = UIColor.blue
    public var tabBarTintColor: UIColor = UIColor.blue
    public var tabBarBackgroundColor: UIColor = UIColor.white
    public var navigationBarTintColor: UIColor = UIColor.blue
    public var navigationBarBackgroundColor: UIColor = UIColor.white
    public var contentTintColor: UIColor = UIColor.colorFromRGB(0x2A2A30)
    public var contentBackgroundColor: UIColor = UIColor.init(white: 0.95, alpha: 1.0)
    public var cautionTintColor: UIColor = UIColor.colorFromRGB(0x2A2A30)
    public var cautionBackgroundColor: UIColor = UIColor.blue
    
    public override init() {
        super.init()
    }
    public init(theme: Appearance.Theme) {
        super.init()
        if theme == .dark {
            self.primaryColor = UIColor.cyan
            self.tabBarTintColor = self.primaryColor
            self.tabBarBackgroundColor = UIColor.black
            self.navigationBarTintColor = self.primaryColor
            self.navigationBarBackgroundColor = UIColor.black
            self.contentTintColor = UIColor.white
            self.contentBackgroundColor = UIColor.init(white: 0.15, alpha: 1.0)
            self.cautionTintColor = UIColor.white
            self.cautionBackgroundColor = UIColor.cyan
        }
    }
    public init(theme: Appearance.Theme, primaryColor: UIColor) {
        super.init()
        self.primaryColor = primaryColor
        self.tabBarTintColor = self.primaryColor
        self.navigationBarTintColor = self.primaryColor
        self.cautionBackgroundColor = self.primaryColor
        if theme == .light {
            self.tabBarBackgroundColor = UIColor.white
            self.navigationBarBackgroundColor = UIColor.white
            self.contentTintColor = UIColor.colorFromRGB(0x2A2A30)
            self.contentBackgroundColor = UIColor.init(white: 0.95, alpha: 1.0)
            self.cautionTintColor = UIColor.colorFromRGB(0x2A2A30)
        }
        else if theme == .dark {
            self.tabBarBackgroundColor = UIColor.black
            self.navigationBarBackgroundColor = UIColor.black
            self.contentTintColor = UIColor.white
            self.contentBackgroundColor = UIColor.init(white: 0.15, alpha: 1.0)
            self.cautionTintColor = UIColor.white
        }
    }
}

open class Appearance: NSObject {
    public enum Theme: String {
        case light = "light"
        case dark = "dark"
        mutating public func toggle() {
            switch self {
            case .light:
                self = .dark
            case .dark:
                self = .light
            }
        }
    }
    private static let keyTheme = [Application.bundleName, ".appearance.theme"].joined()
    
    public static var light: AppearanceConfigure!
    public static var dark: AppearanceConfigure!
    public static func configure(lightConfigure: AppearanceConfigure? = nil, darkConfigure: AppearanceConfigure? = nil) {
        Appearance.light = lightConfigure ?? AppearanceConfigure(theme: .light)
        Appearance.dark = darkConfigure ?? AppearanceConfigure(theme: .dark)
        // update theme
        Appearance.updateTheme()
    }
    public static var configure: AppearanceConfigure {
        var result = (Appearance.theme == .dark) ? Appearance.dark : Appearance.light
        if result == nil {
            result = AppearanceConfigure(theme: .light)
        }
        return result!
    }
    public static func configure(primaryColor: UIColor) {
        Appearance.light = AppearanceConfigure(theme: .light, primaryColor: primaryColor)
        Appearance.dark = AppearanceConfigure(theme: .dark, primaryColor: primaryColor)
        // update theme
        Appearance.updateTheme()
    }
    
    private static var themeSource: Theme?
    public static var theme: Theme {
        get {
            var value = Appearance.themeSource
            if value == nil {
                if let result = UserDefaults.standard.string(forKey: Appearance.keyTheme) {
                    value = Appearance.Theme(rawValue: result)
                }
            }
            if value == nil {
                value = Appearance.Theme.light
            }
            return value!
        }
        set {
            if Appearance.themeSource == newValue { return }
            ILog("theme: \(newValue)")
            Appearance.themeSource = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Appearance.keyTheme)
            UserDefaults.standard.synchronize()
            // update theme
            Appearance.updateTheme()
        }
    }
    public static func updateTheme() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if let rootViewController = window.rootViewController {
            rootViewController.initTheme()
        }
    }
    
    // MARK: - UIKit
    public static var statusBarStyle: UIStatusBarStyle { return (Appearance.theme == .dark) ? .lightContent : .default }
    
    // MARK: - UIColor
    public static var primaryColor: UIColor { return Appearance.configure.primaryColor }
    
    // MARK: - UIColor - tabBar
    public static var tabBarTintColor: UIColor { return Appearance.configure.tabBarTintColor }
    public static var tabBarBackgroundColor: UIColor { return Appearance.configure.tabBarBackgroundColor }

    // MARK: - UIColor - navigationBar
    public static var navigationBarTintColor: UIColor { return Appearance.configure.navigationBarTintColor }
    public static var navigationBarBackgroundColor: UIColor { return Appearance.configure.navigationBarBackgroundColor }
    
    // MARK: - UIColor - content
    public static var contentTintColor: UIColor { return Appearance.configure.contentTintColor }
    public static var contentBackgroundColor: UIColor { return Appearance.configure.contentBackgroundColor }
    
    // MARK: - UIColor - caution
    public static var cautionTintColor: UIColor { return Appearance.configure.cautionTintColor }
    public static var cautionBackgroundColor: UIColor { return Appearance.configure.cautionBackgroundColor }
    
    // MARK: - UIFont
    public static let extraLargeFont : UIFont = UIFont.systemFont(ofSize: 21)
    public static let extraLargeFontBold : UIFont = UIFont.boldSystemFont(ofSize: 21)
    
    public static let largeFont : UIFont = UIFont.systemFont(ofSize: 19)
    public static let largeFontBold : UIFont = UIFont.boldSystemFont(ofSize: 19)
    
    public static let extraMediumFont : UIFont = UIFont.systemFont(ofSize: 17)
    public static let extraMediumFontBold : UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    public static let mediumFont : UIFont = UIFont.systemFont(ofSize: 15)
    public static let mediumFontBold : UIFont = UIFont.boldSystemFont(ofSize: 15)
    
    public static let smallFont : UIFont = UIFont.systemFont(ofSize: 13)
    public static let smallFontBold : UIFont = UIFont.boldSystemFont(ofSize: 13)
    
    public static let extraSmallFont : UIFont = UIFont.systemFont(ofSize: 11)
    public static let extraSmallFontBold : UIFont = UIFont.boldSystemFont(ofSize: 11)
}
