//
//  CTAlert.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 27/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

open class Alert {
    public static func base(_ sender: UIViewController, title: String?, message : String?, buttonOk: String? = nil, buttonCancel: String? = nil, handlerOk: (() -> Void)? = nil, handlerCancel: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let button = buttonCancel {
            let alertAction = UIAlertAction(title: button, style: .default) { (action) in
                if let handlerCancel = handlerCancel {
                    handlerCancel()
                }
            }
            alertController.addAction(alertAction)
        }
        if let button = buttonOk {
            let alertAction = UIAlertAction(title: button, style: .default) { (action) in
                if let handlerOk = handlerOk {
                    handlerOk()
                }
            }
            alertController.addAction(alertAction)
        }
        sender.present(alertController, animated: true, completion: completion)
    }
}
