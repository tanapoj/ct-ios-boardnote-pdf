//
//  CTNavigationController.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class CTNavigationController: UINavigationController {

    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return Appearance.statusBarStyle
    }
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    override open var prefersStatusBarHidden: Bool {
        return self.viewControllers.last?.prefersStatusBarHidden ?? false
    }
    
    // MARK: - Life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        CLog("******* deinit: \(Utility.nameOfClass(self)) *******")
    }
    
    // MARK: - init
    @objc open override func initTheme() {
        self.setNeedsStatusBarAppearanceUpdate()
        self.appearanceDefault()
    }
    @objc open override func initLocalized() {
        
    }
    
    // MARK: - Appearance
    open func appearanceDefault() {
        self.delegate = self
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = Appearance.navigationBarTintColor
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Appearance.navigationBarTintColor,
            NSAttributedString.Key.font: Appearance.largeFontBold
        ]
        self.navigationBar.barTintColor = Appearance.navigationBarBackgroundColor
        //self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - Extension Delegate
extension CTNavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
}
