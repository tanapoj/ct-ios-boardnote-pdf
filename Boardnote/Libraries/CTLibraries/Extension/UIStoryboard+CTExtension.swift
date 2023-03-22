//
//  UIStoryboard+CTExtension.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    private static var storyboardSource: [String:Any] = [:]
    private static func storyboardName(_ name: String) -> UIStoryboard {
        var result = self.storyboardSource[name] as? UIStoryboard
        if result == nil {
            result = UIStoryboard(name: name, bundle: nil)
            self.storyboardSource[name] = result
        }
        return result!
    }
    
    public static func initialViewControllerWithStoryboardName(_ name: String, identifier: String) -> UIViewController {
        let result = self.storyboardName(name);
        return result.instantiateViewController(withIdentifier: identifier)
    }
}
