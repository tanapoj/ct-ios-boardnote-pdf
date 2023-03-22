//
//  LoginViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
//import TweeTextField

class LoginViewController: AbstractViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerViewCenterY: NSLayoutConstraint!
    @IBOutlet private weak var usernameTextField: TweeActiveTextField!
    @IBOutlet private weak var passwordTextField: TweeActiveTextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    
    let vmData: LoginViewModelData = LoginViewModelData()
    
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
        let duration = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: duration, execute: { [weak self] in
            self?.applicationDidBecomeActive()
        })
    }
    
    // MARK: - init
    override func initLocalized() {
        super.initLocalized()
        self.usernameTextField.tweePlaceholder = LocalizedText.username
        self.passwordTextField.tweePlaceholder = LocalizedText.password
        self.loginButton.setTitle(normal: LocalizedText.login)
        self.forgotPasswordButton.setTitle(normal: LocalizedText.forgot_password)
    }
    override func initView() {
        super.initView()
        self.initKeyboard()
        self.initTextField([self.usernameTextField, self.passwordTextField])
        self.imageView.appearanceCornerRadius(20.0)
        self.usernameTextField.appearanceLogin()
        self.passwordTextField.appearanceLogin()
        self.loginButton.appearanceLogin()
        self.forgotPasswordButton.appearanceForgotPassword()
        self.usernameTextField.text = Instance.latestUser
        #if DEBUG
        initTest()
        #endif
    }
    func initTest() {
        self.usernameTextField.text = "pentest_user_02"
        self.passwordTextField.text = "cmnPM1P196ps"
    }

    // MARK: - @IBAction
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        let username = self.usernameTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        self.vmData.login(username: username, password: password)
    }
    @IBAction func forgotPasswordButtonDidTouch(_ sender: Any) {
        Navigation.openUrl(API.forgotPasswordPath)
    }
    
    // MARK: - Handle NotificationCenter
    @objc func applicationDidBecomeActive() {
        Instance.checkVersion()
    }
}

//MARK: - Binding UI
extension LoginViewController {
    func updateViewConstraint(_ textField: UITextField, _ isHide: Bool = true) {
        let constant: CGFloat = (isHide == true) ? 0.0 : -150
        self.containerViewCenterY.constant = constant
        UIView.animate(withDuration: Declaration.duration.updateConstraint) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateViewFailure(message: String) {
        Loading.hide(afterDelay: 1.0, completion: {
            Alert.errorLogin(self, message: message)
        })
    }
}

//MARK: - Binding Data
extension LoginViewController {
    @objc override func viewModelBindingData() {
        self.vmData.onLoginSuccess = onLoginSuccess()
        self.vmData.onLoginFailure = onLoginFailure()
        self.viewModel.data = self.vmData
        super.viewModelBindingData()
    }
    func onLoginSuccess() -> (() -> Void) {
        return {
            Loading.success(completion: {
                Navigation.changeToDestinationViewController(.tabBar)
            })
        }
    }
    func onLoginFailure() -> ((_ message: String?) -> Void) {
        return { [weak self] (message) in
            self?.updateViewFailure(message: message ?? "")
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateViewConstraint(textField, false)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateViewConstraint(textField, true)
    }
    @objc override func textFieldShouldDone() {
        self.loginButtonDidTouch(loginButton)
    }
}
