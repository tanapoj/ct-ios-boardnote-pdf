//
//  CategoryViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 16/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import Siesta

class CategoryViewController: AbstractViewController {
    
    var categories: [MCategory]?
    
    // MARK: - init
    override func initCollectionView() {
        super.initCollectionView()
        CategoryCell.register(with: collectionView)
    }
}

//MARK: - Binding UI
extension CategoryViewController {
    
}

//MARK: - Binding Data
extension CategoryViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = CategoryViewModelData(categories: categories)
        super.viewModelBindingData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CategoryViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MCategory
        let cell = CategoryCell.dequeueReusableCell(with: collectionView, for: indexPath) as! CategoryCell
        cell.configureCell(dataSource)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MCategory
        let title: String = dataSource?.name ?? ""
        let source: [MCategory] = dataSource?.children ?? []
        let type = dataSource?.typeDisplay ?? ""
        if type == MCategoryType.meeting.rawValue {
            if source.count > 0 {
                let controller = Navigation.categoryViewController(title: title, categories: source)
                Navigation.pushToViewController(controller, sender: self)
            }
            else {
                let controller = Navigation.bookViewController(title: title, type: MCategoryType.meeting, category: dataSource)
                Navigation.pushToViewController(controller, sender: self)
            }
        }
        else if type == MCategoryType.news.rawValue {
            let controller = Navigation.bookViewController(title: title, type: MCategoryType.news, category: dataSource)
            Navigation.pushToViewController(controller, sender: self)
        }
        else if type == MCategoryType.documentPage.rawValue {
            let controller = Navigation.bookViewController(title: title, type: MCategoryType.documentPage, category: dataSource)
            Navigation.pushToViewController(controller, sender: self)
        }
    }
}
