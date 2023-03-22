//
//  AbstractNavigationController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AbstractNavigationController: CTNavigationController {
    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func appearanceDefault() {
        super.appearanceDefault()
    }
}
/*
class AbstractNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    override var prefersStatusBarHidden: Bool {
        return self.viewControllers.last?.prefersStatusBarHidden ?? false
    }
    
    func appearanceDefault() {
        self.delegate = self
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = Appearance.whiteColor
        self.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor:Appearance.whiteColor,
            NSAttributedStringKey.font:Appearance.titleFontBold
        ]
        self.navigationBar.barTintColor = Appearance.greenColor
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }
}

extension AbstractNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
}
*/
