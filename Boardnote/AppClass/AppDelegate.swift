//
//  AppDelegate.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 15/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var protectScreenImageView: UIImageView!
    
    func clearAll() {
        Cache.clearAllImage()
        PDF.shared.clearAll()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.backgroundColor = Appearance.greenColor
        setupProtectScreen()
        Appearance.setup()
        PDF.shared.setup()
        Cache.setup()
        NotificationHelper.shared.setup(launchOptions: launchOptions)
//        clearAll()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        addProtectScreen()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        addProtectScreen()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        removeProtectScreen()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        removeProtectScreen()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        CLog("Device Token: \(token)")
        Instance.deviceToken = token
        // move to validateLogin when applicationDidBecomeActive on tabbar
        // API.saveToken(token, userId: Instance.user?.id)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        CLog("Failed to register: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        CLog("Receive notification: \(userInfo)")
    }
}

// MARK: - splash screen image
extension AppDelegate {
    func setupProtectScreen() {
        protectScreenImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        protectScreenImageView.backgroundColor = UIColor.clear
        protectScreenImageView.image = UIImage.init(named: "background_00")
        protectScreenImageView.isHidden = true
        protectScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        protectScreenImageView.clipsToBounds = true
        protectScreenImageView.contentMode = .scaleAspectFill
        window?.addSubview(protectScreenImageView)
        // set constraint
        if let containerView = window {
            protectScreenImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
            protectScreenImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
            protectScreenImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
            protectScreenImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        }
    }
    func addProtectScreen() {
        window?.bringSubviewToFront(protectScreenImageView)
        protectScreenImageView.isHidden = false
    }
    func removeProtectScreen() {
        protectScreenImageView.isHidden = true
    }
}
