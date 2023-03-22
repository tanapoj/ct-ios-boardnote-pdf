//
//  CTScreen.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 27/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public class Screen {
    public enum ModelSize {
        case unknown
        case iPhone_4
        case iPhone_4_7
        case iPhone_5_5
        case iPad_7_9
        case iPad_12_9
        case iPad_Pro
    }
    
    public static var size : CGSize {
        get { return UIScreen.main.bounds.size }
    }
    public static var width : CGFloat {
        get { return UIScreen.main.bounds.width }
    }
    public static var height : CGFloat {
        get { return UIScreen.main.bounds.height }
    }
    public static var density: String {
        return "\(UIScreen.main.nativeBounds.width)*\(UIScreen.main.nativeBounds.height)"
    }
    public static var modelSize : ModelSize {
        get {
            var result: ModelSize = .unknown
            if self.width <= 320        { result = .iPhone_4 }
            else if self.width <= 375   { result = .iPhone_4_7 }
            else if self.width <= 414   { result = .iPhone_5_5 }
            else if self.width <= 768   { result = .iPad_7_9 }
            else if self.width <= 1024  { result = .iPad_12_9 }
            else if self.width >  1024  { result = .iPad_Pro }
            return result
        }
    }
    public static var isTablet : Bool {
        get { return (self.modelSize == .iPad_7_9 || self.modelSize == .iPad_12_9 || self.modelSize == .iPad_Pro) }
    }
}
