//
//  AbstractTabBarController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AbstractTabBarController: CTTabBarController {
    
    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationHelper.shared.completionHandler()
        let duration = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: duration, execute: { [weak self] in
            self?.checkVersion()
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        CLog("******* deinit: \(Utility.nameOfClass(self)) *******")
    }
    
    // MARK: - property
    /* Change data source
     override var dataTabBars: [MTabBars] {
     return []
     }
     */
    override var sourceViewControllers:[UIViewController] {
        var result = [UIViewController]()
        result.append(Navigation.sourceTabBarViewController(.home))
        result.append(Navigation.sourceTabBarViewController(.document))
        result.append(Navigation.sourceTabBarViewController(.calendar))
        result.append(Navigation.sourceTabBarViewController(.profile))
        return result
    }
    
    // MARK: - Handle NotificationCenter
    @objc func applicationDidBecomeActive() {
        API.validateToken(onSuccess: { [weak self] in
            if let token = Instance.deviceToken {
                API.saveToken(token, userId: Instance.user?.id)
            }
            self?.checkVersion()
        }, onFailure: { (error, status) in
            Alert.errorValidateToken()
        })
    }
    
    func checkVersion() {
        Instance.checkVersion()
    }
}
