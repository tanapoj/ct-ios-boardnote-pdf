//
//  CTTabBarController.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class CTTabBarController: UITabBarController {
    public struct UIOptions : OptionSet {
        public var rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        public static let theme        = UIOptions(rawValue: 1 << 0)
        public static let localized    = UIOptions(rawValue: 1 << 1)
    }
    
    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .lightContent
    }
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.selectedViewController?.preferredStatusBarUpdateAnimation ?? .fade
    }
    override open var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    // MARK: - property
    open var dataTabBars:[MTabBars] {
        if let path = Assets.path(forResource: "TabBars", ofType: "plist"), let source = NSArray(contentsOfFile: path) as? [[String:Any]] {
            let result = MTabBars.create(source)
            return result
        }
        return []
    }
    open var sourceViewControllers:[UIViewController] {
        return [UIViewController]()
    }
    
    // MARK: - Life cycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.setupTabViewControllers()
        self.initTheme()
        self.initLocalized()
    }
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
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = Appearance.tabBarTintColor
        self.tabBar.barTintColor = Appearance.tabBarBackgroundColor
        self.updateViewControllers([.theme])
    }
    @objc open override func initLocalized() {
        for (index, element) in (self.tabBar.items?.enumerated())! {
            let isIndexValid = self.dataTabBars.indices.contains(index)
            var title: String?
            if isIndexValid {
                let tabBar = self.dataTabBars[index]
                title = tabBar.titleLocalized
            }
            element.title = title
        }
        self.updateViewControllers([.localized])
    }
    
    // MARK: - setup
    open func setupTabViewControllers() {
        self.viewControllers = self.sourceViewControllers
        
        for (index, element) in (self.tabBar.items?.enumerated())! {
            let isIndexValid = self.dataTabBars.indices.contains(index)
            var title: String?
            var image: UIImage?
            var selectedImage: UIImage?
            if isIndexValid {
                let tabBar = self.dataTabBars[index]
                title = tabBar.titleLocalized
                image = tabBar.image
                selectedImage = tabBar.selectedImage
            }
            
            element.title = title
            element.image = image
            element.selectedImage = selectedImage
        }
    }
    
    // MARK: - update
    open func updateViewControllers(_ options: UIOptions) {
        self.viewControllers?.forEach({ (viewController) in
            if options.contains(.theme)     { viewController.initTheme() }
            if options.contains(.localized) { viewController.initLocalized() }
            if let navigationController = viewController as? UINavigationController {
                navigationController.viewControllers.forEach({ (viewController) in
                    if options.contains(.theme)     { viewController.initTheme() }
                    if options.contains(.localized) { viewController.initLocalized() }
                })
            }
        })
    }
}
