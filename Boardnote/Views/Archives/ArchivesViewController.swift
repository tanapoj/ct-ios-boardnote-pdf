//
//  ArchivesViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 17/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class ArchivesViewController: AbstractViewController {
    // MARK: - override
    override var rightBarButtonItems: [UIBarButtonItem]? {
        let button = UIButton.buttonBarText(LocalizedText.search, target: self, action: #selector(self.actionRightBarButtonDidTouch(_:)))
        self.rightButtonBar = button
        let barButton = UIBarButtonItem(customView: button)
        return [barButton]
    }
    
    // MARK: - init
    override func initCollectionView() {
        super.initCollectionView()
        ArchivesCell.register(with: collectionView)
    }
    
    // MARK: - Action
    @objc override func actionRightBarButtonDidTouch(_ sender: Any) {
        let controller = Navigation.searchViewController()
        controller.hidesBottomBarWhenPushed = true
        Navigation.pushToViewController(controller, sender: self)
    }
}

//MARK: - Binding UI
extension ArchivesViewController {
    
}

//MARK: - Binding Data
extension ArchivesViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = ArchivesViewModelData()
        super.viewModelBindingData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension ArchivesViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeetingArchive
        let cell = ArchivesCell.dequeueReusableCell(with: collectionView, for: indexPath) as! ArchivesCell
        cell.configureCell(dataSource)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeetingArchive
        let title: String = dataSource?.title ?? ""
        let controller = Navigation.bookViewController(title: title, type: MCategoryType.meetingArchive, meetingArchive: dataSource)
        Navigation.pushToViewController(controller, sender: self)
    }
}
