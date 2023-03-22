//
//  UITextFieldExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
//import TweeTextField

extension UITextField {
    
}

extension TweeActiveTextField {
    // MARK: Appearance
    func appearanceLogin() {
        self.font = Appearance.extraMediumFont
        self.lineColor = Appearance.lightGreyColor
        self.lineWidth = 1.0
        self.placeholderColor = Appearance.lightGreyColor
        self.placeholderLabel.font = Appearance.extraMediumFont
        self.textColor = Appearance.whiteColor
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) ||
            action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft(_:)) ||
            action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight(_:)) ||
            action == #selector(UIResponderStandardEditActions.toggleBoldface(_:)) ||
            action == #selector(UIResponderStandardEditActions.toggleItalics(_:)) ||
            action == #selector(UIResponderStandardEditActions.toggleUnderline(_:))
        {
            return false
        }
        return false//super.canPerformAction(action, withSender: sender)
    }
}
