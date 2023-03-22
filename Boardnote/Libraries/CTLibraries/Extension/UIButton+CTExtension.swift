//
//  UIButton+CTExtension.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    @objc public func setTitleColor(normal: UIColor?, highlighted: UIColor? = nil, disabled: UIColor? = nil) {
        let colorHighlighted = (highlighted) ?? normal?.withAlphaComponent(0.5)
        let colorDisabled = (disabled) ?? normal?.withAlphaComponent(0.5)
        self.setTitleColor(normal, for: .normal)
        self.setTitleColor(colorHighlighted, for: .highlighted)
        self.setTitleColor(colorDisabled, for: .disabled)
    }
    @objc public func setTitle(normal: String?) {
        self.setTitle(normal, for: .normal)
        self.setTitle(normal, for: .highlighted)
        self.setTitle(normal, for: .disabled)
    }
    @objc public func setImage(normal: UIImage?, highlighted: UIImage? = nil, disabled: UIImage? = nil) {
        let imageHighlighted = (highlighted) ?? normal?.alpha(0.5)
        let imageDisabled = (disabled) ?? normal?.alpha(0.5)
        self.setImage(normal, for: .normal)
        self.setImage(imageHighlighted, for: .highlighted)
        self.setImage(imageDisabled, for: .disabled)
    }
    @objc public func setBackgroundColor(normal: UIColor?, highlighted: UIColor? = nil, disabled: UIColor? = nil) {
        let color = normal ?? UIColor.white
        let imageNormal = UIImage(color: normal ?? UIColor.white)
        let imageHighlighted = UIImage(color: highlighted ?? color.withAlphaComponent(0.5))
        let imageDisabled = UIImage(color: disabled ?? color.withAlphaComponent(0.5))
        self.setBackgroundImage(imageNormal, for: .normal)
        self.setBackgroundImage(imageHighlighted, for: .highlighted)
        self.setBackgroundImage(imageDisabled, for: .disabled)
    }
    
    // MARK: Generate
    @objc public static func buttonBar(_ target: Any?, action: Selector, image: UIImage? = nil, title: String? = nil) -> UIButton {
        let result: UIButton = UIButton(type: .custom)
        result.setTitle(normal: title)
        result.setImage(normal: image)
        result.addTarget(target, action: action, for: .touchUpInside)
        result.backgroundColor = UIColor.clear
        result.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        result.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        return result
    }
    
    // MARK: Appearance
    @objc public func appearanceDefault() {
        self.appearanceCornerRadius()
        self.backgroundColor = Appearance.primaryColor
        self.setTitleColor(normal: UIColor.white)
        self.titleLabel?.font = Appearance.mediumFontBold
    }
    @objc public func appearanceCaution() {
        self.appearanceCornerRadius()
        self.backgroundColor = Appearance.cautionBackgroundColor
        self.setTitleColor(normal: Appearance.cautionTintColor)
        self.titleLabel?.font = Appearance.mediumFontBold
    }
}
