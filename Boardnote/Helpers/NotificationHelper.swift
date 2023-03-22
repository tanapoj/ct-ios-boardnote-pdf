//
//  NotificationHelper.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 01/10/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationHelper: NSObject {
    var userInfo: [AnyHashable:Any]?
    
    // MARK: - Shared Instance
    static let shared = NotificationHelper()
    
    func setup(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        registerForPushNotifications()
        DispatchQueue.main.async(execute: { [weak self] in
            self?.receiveForPushNotifications(launchOptions: launchOptions)
        })
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            CLog("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            CLog("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    func receiveForPushNotifications(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let userInfo = launchOptions?[.remoteNotification] as? [String: Any] else { return }
        self.userInfo = userInfo
    }
    
    func completionHandler() {
        guard let userInfo = self.userInfo else { return }
        guard let aps = userInfo["aps"] as? [String:Any] else { return }
        var documentReady: Bool?
        var meetingID: Int?
        if let docReady = aps["documentReady"] as? Int { documentReady = (docReady == 1) }
        if let docReady = aps["documentReady"] as? String { documentReady = (docReady == "1") }
        if let mid = aps["meetingID"] as? Int { meetingID = mid }
        if let mid = aps["meetingID"] as? String { meetingID = Int(mid) }
        guard let ready = documentReady else { return }
        if ready == true {
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                if let navigation = tabBarController.selectedViewController as? AbstractNavigationController {
                    navigation.popToRootViewController(animated: false)
                    if let sender = navigation.viewControllers.first {
                        let meetingId: Int = meetingID ?? 0
                        let type = aps["meetingType"] as? String ?? MCategoryType.meeting.rawValue
                        let controller = Navigation.bookDetailViewController(meetingId: meetingId, meetingType: type)
                        Navigation.pushToViewController(controller, sender: sender)
                    }
                }
            }
        }
        else { // send view calendar
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 2
                if let navigation = tabBarController.selectedViewController as? AbstractNavigationController {
                    navigation.popToRootViewController(animated: false)
                    if let controller = navigation.viewControllers.first as? CalendarViewController {
                        controller.meetingTime = aps["meetingTime"] as? String
                    }
                }
            }
        }
        // clear
        self.userInfo = nil
    }
}

extension NotificationHelper: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        CLog("openSettingsFor")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        CLog("Present notification: \(notification.request.content.userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.userInfo = response.notification.request.content.userInfo
        self.completionHandler()
        completionHandler()
    }
}
