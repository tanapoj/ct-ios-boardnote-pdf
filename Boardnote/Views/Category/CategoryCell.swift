//
//  CategoryCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 16/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class CategoryCell: CTCollectionViewCell {
    // MARK: - override
    override class var cellId: String { return "CategoryCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(_ dataSource: MCategory?) {
        self.containerView.backgroundColor = dataSource?.colorDisplay
        self.containerView.appearanceHome()
        self.iconImageView.setImage(urlString: dataSource?.icon)
        self.titleLabel.appearanceTitleWhite()
        self.titleLabel.text = dataSource?.name
    }
}

