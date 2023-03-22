//
//  LoginViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class LoginViewModelData: CTViewModelData {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((_ message: String?) -> Void)?
    
    override func onLocalLoad() {
        Cache.clearAllImageAndData()
        onLocalSuccess?(nil)
        onLocalCompletion?()
    }
    
    func login(username: String, password: String) {
        Loading.show()
        if username.count > 0 && password.count > 0 {
            API.login(username, password, onSuccess: { [weak self] in
                self?.onLoginSuccess?()
            }, onFailure: { [weak self] (error, status) in
                var message = LocalizedText.alert_message_valid_login
                if let code = error.code {
                    message = code.localized
                }
                self?.onLoginFailure?(message)
            })
        }
        else {
            self.onLoginFailure?(LocalizedText.alert_message_valid_login)
        }
    }
}
