//
//  BookViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 16/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class BookViewController: AbstractViewController {
    
    // MARK: - property
    var type: MCategoryType!
    var category: MCategory?
    var meetingArchive: MMeetingArchive?

    fileprivate var focusIndexPath: IndexPath?

    // MARK: - Life cycle
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (contexr) in
            self?.updateCollectionView()
        }) { [weak self] (context) in
            self?.updateCollectionView()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: - init
    override func initCollectionView() {
        super.initCollectionView()
        BookCell.register(with: collectionView)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.updateCollectionView()
    }
}

//MARK: - Binding UI
extension BookViewController {
    func updateCollectionView() {
        if let layout = self.collectionView.collectionViewLayout as? MMBannerLayout {
            let gap: CGFloat = 16.0
            let tab: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 0
            let nav: CGFloat = self.navigationController?.navigationBar.frame.size.height ?? 0
            let status: CGFloat = UIApplication.shared.statusBarFrame.height
            let height: CGFloat = min(Screen.width, Screen.height) - tab - nav - status - (gap * 2.0)
            let width: CGFloat = height * 1 / 1.4142
            let size: CGSize = CGSize(width: width, height: height)
            let itemSpace: CGFloat = max(((Screen.width - width) / 2) - (width / 3.5), (gap * 2))
            layout.itemSpace = itemSpace
            layout.itemSize = size//self.collectionView.frame.insetBy(dx: 40, dy: 40).size
            layout.minimuAlpha = 1.0//0.5
        }
    }
}

//MARK: - Binding Data
extension BookViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = BookViewModelData(type: self.type, category: self.category, meetingArchive: self.meetingArchive)
        super.viewModelBindingData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension BookViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeeting
        let cell = BookCell.dequeueReusableCell(with: collectionView, for: indexPath) as! BookCell
        cell.configureCell(dataSource, category: self.category)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.focusIndexPath == indexPath {
            let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeeting
            let controller = Navigation.bookDetailViewController(meetingId: dataSource?.id, meetingType: dataSource?.type)
            Navigation.pushToViewController(controller, sender: self)
        }
    }
}

// MARK: - BannerLayoutDelegate
extension BookViewController: BannerLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, focusAt indexPath: IndexPath) {
        self.focusIndexPath = indexPath
        CLog("Focus At \(indexPath)")
    }
}
