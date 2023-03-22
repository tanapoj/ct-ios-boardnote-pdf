//
//  IntroViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class IntroViewModelData: CTViewModelData {
    override func onLocalLoad() {
        ui?.showLoader()
        API.validURL(onCompletion: {
            Instance.prepareData({ [weak self] (completed) in
                if completed == true {
                    self?.onLocalCompletion?()
                }
                else {
                    self?.onLocalFailure?()
                }
            })
        })
    }
}
