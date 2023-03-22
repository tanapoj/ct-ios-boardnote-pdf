//
//  UILabel+CTExtension.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    // MARK: Appearance
    @objc public func appearanceCautionTitle() {
        self.textColor = Appearance.cautionTintColor
        self.font = Appearance.extraMediumFontBold
        self.numberOfLines = 0
    }
    @objc public func appearanceCautionSubTitle() {
        self.textColor = Appearance.cautionTintColor
        self.font = Appearance.mediumFont
        self.numberOfLines = 0
    }
}
