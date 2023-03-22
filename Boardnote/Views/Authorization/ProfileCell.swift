//
//  ProfileCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 20/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class ProfileCell: CTTableViewCell {
    // MARK: - override
    override class var cellId: String { return "ProfileCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageViewWidth: NSLayoutConstraint!
    
    var dataSource: MProfile?
    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateConstraintCell()
    }
    
    // MARK: - constraint
    func updateConstraintCell() {
        iconImageViewWidth.constant = dataSource?.imageWidth ?? 16.0
    }
    
    func configureCell(_ dataSource: MProfile?) {
        setSelectedBackgroundPrimaryColor()
        self.dataSource = dataSource
        backgroundColor = UIColor.clear
        titleLabel.appearanceTitle()
        titleLabel.text = dataSource?.title
        titleLabel.numberOfLines = 2
        if dataSource?.isHeader == true {
            iconImageView.setImage(urlString: dataSource?.imageName)
        }
        else {
            let color = dataSource?.color ?? Appearance.lightBlackColor
            iconImageView.image = UIImage(named: dataSource?.imageName ?? "")?.replaceColor(color)
        }
        selectionStyle = (dataSource?.isSelect == true) ? .default : .none
        accessoryType = (dataSource?.isSelect == true) ? .disclosureIndicator : .none
        if let color = dataSource?.color {
            titleLabel.textColor = color
        }
    }
}
