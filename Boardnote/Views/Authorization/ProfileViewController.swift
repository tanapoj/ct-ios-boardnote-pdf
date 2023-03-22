//
//  ProfileViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 18/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class ProfileViewController: AbstractViewController {
    
    let vmData: ProfileViewModelData = ProfileViewModelData()
    
    // MARK: - init
    override func initTableView() {
        super.initTableView()
        ProfileCell.register(with: tableView)
    }
}

//MARK: - Binding UI
extension ProfileViewController {
    @objc override func viewModelBindingUI() {
        super.viewModelBindingUI()
        viewModel.ui.refreshParentTableView?.subviews.forEach({ (view) in
            if let refreshControl = view as? UIRefreshControl {
                refreshControl.removeFromSuperview()
            }
        })
    }
    
    func updateViewFailure(message: String) {
        Loading.hide(afterDelay: 1.0, completion: {
            Alert.errorLogin(self, message: message)
        })
    }
}

//MARK: - Binding Data
extension ProfileViewController {
    @objc override func viewModelBindingData() {
        vmData.onLogOutSuccess = onLogOutSuccess()
        vmData.onLogOutFailure = onLogOutFailure()
        viewModel.data = vmData
        super.viewModelBindingData()
    }
    func onLogOutSuccess() -> (() -> Void) {
        return {
            Loading.success(completion: {
                Navigation.changeToDestinationViewController(.login)
            })
        }
    }
    func onLogOutFailure() -> ((_ message: String?) -> Void) {
        return { [weak self] (message) in
            self?.updateViewFailure(message: message ?? "")
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.dataSource.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = viewModel.data.dataSource[section] as! MProfiles
        return dataSource.items?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = viewModel.data.dataSource[indexPath.section] as! MProfiles
        let source = dataSource.items?[indexPath.row]
        let cell = ProfileCell.dequeueReusableCell(with: tableView, for: indexPath) as! ProfileCell
        cell.configureCell(source)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataSource = viewModel.data.dataSource[indexPath.section] as! MProfiles
        let source = dataSource.items?[indexPath.row]
        return source?.heightForRow ?? Declaration.heightForRow
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataSource = viewModel.data.dataSource[indexPath.section] as! MProfiles
        let source = dataSource.items?[indexPath.row]
        if source?.title == LocalizedText.change_password {
            Navigation.openUrl(API.forgotPasswordPath)
        }
        else if source?.title == LocalizedText.about_us {
            let controller = Navigation.aboutUsViewController()
            controller.hidesBottomBarWhenPushed = true
            Navigation.pushToViewController(controller, sender: self)
        }
        else if source?.title == LocalizedText.logout {
            vmData.logout()
        }
    }
}
