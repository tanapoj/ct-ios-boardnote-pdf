//
//  IntroViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class IntroViewController: AbstractViewController {
    
}

//MARK: - Binding UI
extension IntroViewController {
    @objc override func updateView() {
        let destination: Navigation.DestinationViewController = (Instance.user != nil) ? .tabBar : .login
        Navigation.changeToDestinationViewController(destination)
    }
    
    @objc override func updateViewFailure() {
        self.viewModel.ui.hideLoader()
        self.viewModel.ui.showCaution(unit: .retry)
    }
    
    @objc override func cautionDidRetry() -> (() -> Void) {
        return { [weak self] in
            self?.viewModel.ui.showLoader()
            Utility.callback(1.0) {
                self?.viewModel.data.onLocalLoad()
            }
        }
    }
}

//MARK: - Binding Data
extension IntroViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = IntroViewModelData()
        super.viewModelBindingData()
    }
}
