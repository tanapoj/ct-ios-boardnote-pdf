//
//  CTNavigation.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Navigation
open class Navigation {
    
    // MARK: - Utility
    public static func changeToViewController(_ controller: UIViewController, duration: Double = 1.0) {
        guard let window = UIApplication.shared.keyWindow else { return }
        Utility.callback(duration) {
            ILog("Change to \(controller)")
            window.rootViewController = controller
        }
    }
    
    // MARK: - openURL
    public static func openUrl(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    public static func openSettingsApplication() {
        self.openUrl(UIApplication.openSettingsURLString)
    }
}
