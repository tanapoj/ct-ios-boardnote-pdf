//
//  ProfileViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class ProfileViewModelData: CTViewModelData {
    override var viewForFooter: UIView? { return nil }
    override var heightForHeader: CGFloat { return 16.0 }
    override var heightForFooter: CGFloat { return 16.0 }
    override var enableLoadMore: Bool { return false }
    var onLogOutSuccess: (() -> Void)?
    var onLogOutFailure: ((_ message: String?) -> Void)?
    
    override init() {
        super.init()
    }
    
    override func onLocalLoad() {
        var source:[MProfiles] = []
        do {
            let result = MProfiles(JSON: [:])!
            result.items = []
            do {
                let profile = MProfile(JSON: [:])!
                profile.title = Instance.user?.displayName
                profile.imageName = Instance.user?.avatar
                profile.imageWidth = 60.0
                profile.heightForRow = 96.0
                profile.isHeader = true
                result.items?.append(profile)
            }
            do {
                let profile = MProfile(JSON: [:])!
                profile.title = LocalizedText.change_password
                profile.imageName = "ic_key"
                profile.imageWidth = 24.0
                profile.heightForRow = 60.0
                profile.isSelect = true
                result.items?.append(profile)
            }
            do {
                let profile = MProfile(JSON: [:])!
                profile.title = LocalizedText.about_us
                profile.imageName = "ic_info"
                profile.imageWidth = 24.0
                profile.heightForRow = 60.0
                profile.isSelect = true
                result.items?.append(profile)
            }
            source.append(result)
        }
        do {
            let result = MProfiles(JSON: [:])!
            result.items = []
            do {
                let profile = MProfile(JSON: [:])!
                profile.title = LocalizedText.logout
                profile.imageName = "ic_exit"
                profile.imageWidth = 24.0
                profile.heightForRow = 60.0
                profile.isSelect = true
                profile.color = Appearance.redColor
                result.items?.append(profile)
            }
            source.append(result)
        }
        onLocalSuccess?(source)
        onLocalCompletion?()
    }
    
    func onFailure(error: MError) {
        var message = LocalizedText.alert_message_error
        if let code = error.code {
            message = code.localized
        }
        self.onLogOutFailure?(message)
    }
    
    func logout() {
        Loading.show()
        API.saveToken(Instance.deviceToken ?? "", userId: nil, onSuccess: { [weak self] in
            self?.saveTokenSuccess()
        }, onFailure: { [weak self] (error, status) in
            self?.onFailure(error: error)
        })
    }
    
    func saveTokenSuccess() {
        API.logOut(onSuccess: {
            Cache.clearAllImageAndData(onCompletion: { [weak self] in
                Instance.user = nil
                self?.onLogOutSuccess?()
            })
        }, onFailure: { [weak self] (error, status) in
            self?.onFailure(error: error)
        })
    }
}
