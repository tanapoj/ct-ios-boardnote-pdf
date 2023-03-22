//
//  CTAppearanceExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Appearance {
    static func setup() {
        Appearance.configure(primaryColor: Appearance.greenColor)
        Appearance.light.navigationBarTintColor = UIColor.white
        Appearance.light.navigationBarBackgroundColor = Appearance.greenColor
        Appearance.light.contentBackgroundColor = UIColor.white
        Appearance.dark.contentBackgroundColor = UIColor.black
    }
    
    // MARK: - UIColor
    static let greenColor: UIColor = UIColor.colorFromRGB(0x46A262)
    static let greyColor: UIColor = UIColor.colorFromRGB(0xC1C1C1)
    static let lightGreyColor: UIColor = UIColor.colorFromRGB(0xE7E7E7)
    static let blackColor: UIColor = UIColor.colorFromRGB(0x2A2A30)
    static let lightBlackColor: UIColor = UIColor.colorFromRGB(0x666666)
    static let whiteColor: UIColor = UIColor.init(white: 0.95, alpha: 1.0)
    static let blueColor: UIColor = UIColor.colorFromRGB(0x33ADFA)
    static let redColor: UIColor = UIColor.colorFromRGB(0xFF6961)
    static let yellowColor: UIColor = UIColor.colorFromRGB(0xFFF17F)
    static let lightYellowColor: UIColor = UIColor.colorFromRGB(0xFFEDBF)
    static let pdfBackgroundColor: UIColor = UIColor.init(red:0.7, green:0.7, blue:0.7, alpha: 1.0)
}
