//
//  AudienceViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 24/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AudienceViewController: AbstractViewController {
    override var collectionViewHeightForRow: CGFloat { return 80.0 }
    var meeting: MMeeting?
    // MARK: - override
    override var rightBarButtonItems: [UIBarButtonItem]? {
        var result: [UIBarButtonItem] = []
        do {
            let button = UIButton.buttonBarCheckIn(self, action: #selector(self.buttonBarCheckInDidTouch(_:)))
            let barButton = UIBarButtonItem(customView: button)
            result.append(barButton)
        }
        return result
    }
    // MARK: - init
    override func initCollectionView() {
        super.initCollectionView()
        AudienceCell.register(with: collectionView)
    }
    
    // MARK: - Action
    @objc func buttonBarCheckInDidTouch(_ sender: Any) {
        let controller = Navigation.checkinViewController(meeting: meeting)
        controller.hidesBottomBarWhenPushed = true
        Navigation.pushToViewController(controller, sender: self)
    }
}

//MARK: - Binding UI
extension AudienceViewController {
    
}

//MARK: - Binding Data
extension AudienceViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = AudienceViewModelData(meetingId: meeting?.id) 
        super.viewModelBindingData()
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension AudienceViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MUser
        let cell = AudienceCell.dequeueReusableCell(with: collectionView, for: indexPath) as! AudienceCell
        cell.configureCell(dataSource)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // nothing
    }
}
