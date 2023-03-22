//
//  UIButtonExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    // MARK: Generate
    static func buttonBarBack(_ target: Any?, action: Selector) -> UIButton {
        let image = #imageLiteral(resourceName: "ic_back").replaceColor(Appearance.whiteColor)
        let result = self.buttonBar(target, action: action, image: image)
        result.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 16)
        return result
    }
    static func buttonBarPdfTool(_ image: UIImage, target: Any?, action: Selector) -> UIButton {
        let image = image.replaceColor(Appearance.whiteColor)
        let result = self.buttonBar(target, action: action, image: image)
        return result
    }
    static func buttonBarText(_ text: String, target: Any?, action: Selector) -> UIButton {
        let result = self.buttonBar(target, action: action, title: text)
        result.setTitleColor(normal: UIColor.white)
        return result
    }
    static func buttonBarCheckIn(_ target: Any?, action: Selector) -> UIButton {
        let result: UIButton = UIButton(type: .custom)
        result.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        result.addTarget(target, action: action, for: .touchUpInside)
        result.appearanceCheckIn()
        result.backgroundColor = UIColor.clear
        return result
    }
    static func buttonBarAudience(_ target: Any?, action: Selector) -> UIButton {
        let result: UIButton = UIButton(type: .custom)
        result.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        result.addTarget(target, action: action, for: .touchUpInside)
        result.appearanceAudience()
        result.backgroundColor = UIColor.clear
        return result
    }
    
    // MARK: Appearance
    @objc public func appearanceDefault(isEnabled: Bool = true) {
        self.appearanceCornerRadius()
        self.backgroundColor = (isEnabled) ? Appearance.primaryColor : Appearance.greyColor
        self.setTitleColor(normal: UIColor.white)
        self.titleLabel?.font = Appearance.mediumFontBold
        self.isEnabled = isEnabled
    }
    
    func appearanceCheckIn() {
        self.appearanceDefault()
        self.setImage(normal: #imageLiteral(resourceName: "ic_checkin").replaceColor(Appearance.whiteColor))
        self.setTitle(normal: " \(LocalizedText.check_in)")
    }
    func appearanceAudience() {
        self.appearanceDefault()
        self.setImage(normal: #imageLiteral(resourceName: "ic_group"))
        self.setTitle(normal: " \(LocalizedText.audience)")
    }
    
    func appearanceLogin() {
        self.appearanceDefault()
        self.titleLabel?.font = Appearance.extraMediumFontBold
    }
    func appearanceForgotPassword() {
        self.backgroundColor = UIColor.clear
        self.setTitleColor(normal: UIColor.white)
        self.titleLabel?.font = Appearance.mediumFontBold
    }
    
    func appearancePdfBack() {
        self.backgroundColor = UIColor.clear
        self.setImage(normal: #imageLiteral(resourceName: "ic_back").replaceColor(UIColor.white))
        self.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 8, bottom: 10, right: 56)
    }
    func appearancePdfTools(_ image: UIImage) {
        self.backgroundColor = UIColor.clear
        self.setImage(normal: image.replaceColor(UIColor.white))
        self.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
}
