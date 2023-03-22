//
//  CTAlertExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 27/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Alert {
    static func calendar(_ sender: UIViewController, sourceView: UIView, sourceRect: CGRect, sourceData: [MMeeting]) {
        let row = min(sourceData.count, PopupCalendarView.limitRow)
        var title = ""
        for _ in 1...row {
            title.append("\n\n\n")
        }
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        do { // custom view
            let spacing:CGFloat = 16
            let height:CGFloat = PopupCalendarView.heightForRow * CGFloat(row)
            let rect = CGRect(x: 0, y: spacing, width: alertController.view.bounds.size.width, height: height)
            let view = PopupCalendarView.instanceFromNib(frame: rect, source: sourceData)
            view.handler = { (meeting) in
                alertController.dismiss(animated: true, completion: {
                    let controller = Navigation.bookDetailViewController(meetingId: meeting.id, meetingType: meeting.type)
                    Navigation.pushToViewController(controller, sender: sender)
                })
            }
            alertController.view.addSubview(view)
        }
        do { // cancel
            let alertAction = UIAlertAction(title: LocalizedText.cancel, style: .cancel, handler: nil)
            alertController.addAction(alertAction)
        }
        sender.present(alertController, animated: true, completion: nil)
        if let popOver = alertController.popoverPresentationController {
            popOver.sourceView = sourceView
            popOver.sourceRect = sourceRect
        }
    }
    
    static func confirmPdf(_ sender: UIViewController, handlerOk: (() -> Void)?, handlerCancel: (() -> Void)?) {
        Alert.base(sender,
                   title: LocalizedText.alert_title_caution,
                   message: LocalizedText.alert_message_pdf_leave,
                   buttonOk: LocalizedText.alert_action_save,
                   buttonCancel: LocalizedText.alert_action_do_not_save,
                   handlerOk: handlerOk,
                   handlerCancel: handlerCancel)
    }
    
    static func errorLogin(_ sender: UIViewController, message: String? = nil, handlerOk: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        Alert.base(sender,
                   title: LocalizedText.alert_title_warning,
                   message: message ?? LocalizedText.alert_message_valid_login,
                   buttonOk: LocalizedText.alert_action_ok,
                   handlerOk: handlerOk,
                   completion: completion)
    }

    static func errorCheckIn(_ sender: UIViewController, message: String? = nil, handlerOk: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        Alert.base(sender,
                   title: LocalizedText.alert_title_warning,
                   message: message ?? LocalizedText.alert_message_error,
                   buttonOk: LocalizedText.alert_action_ok,
                   handlerOk: handlerOk,
                   completion: completion)
    }
    
    static func errorValidateToken(completion: (() -> Void)? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        Alert.base(controller,
                   title: LocalizedText.alert_title_warning,
                   message: LocalizedText.alert_message_valid_token,
                   buttonOk: LocalizedText.alert_action_ok,
                   handlerOk: {
                    API.saveToken(Instance.deviceToken ?? "", userId: nil)
                    Navigation.changeToDestinationViewController(.login)
        }, completion: completion)
    }
    
    static func errorCertificatePinning(completion: (() -> Void)? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        Alert.base(controller,
                   title: LocalizedText.alert_title_warning,
                   message: LocalizedText.alert_message_valid_certificate,
                   buttonOk: LocalizedText.alert_action_ok,
                   handlerOk: {
                    API.saveToken(Instance.deviceToken ?? "", userId: nil)
                    Navigation.changeToDestinationViewController(.login)
        }, completion: completion)
    }
    
    static func latestVersion(completion: (() -> Void)? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController else { return }
        Alert.base(controller,
                   title: LocalizedText.alert_title_warning,
                   message: LocalizedText.alert_message_latest_version,
                   buttonOk: LocalizedText.alert_action_ok,
                   handlerOk: {
                    Navigation.openUrl(API.downloadAppPath)
        }, completion: completion)
    }
}
