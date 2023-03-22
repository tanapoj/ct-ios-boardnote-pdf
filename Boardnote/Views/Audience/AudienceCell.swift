//
//  AudienceCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 12/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AudienceCell: CTCollectionViewCell {
    // MARK: - override
    override class var cellId: String { return "AudienceCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configureCell(_ dataSource: MUser?) {
        self.backgroundColor = UIColor.clear
        self.titleLabel.appearanceTitle()
        self.titleLabel.text = dataSource?.displayName
        self.titleLabel.numberOfLines = 2
        self.userImageView.setImage(urlString: dataSource?.avatar)
        self.userImageView.appearanceCornerRadius()
        let color: UIColor = (dataSource?.checkedIn == true) ? Appearance.greenColor : Appearance.greyColor
        self.iconImageView.image = #imageLiteral(resourceName: "ic_check").replaceColor(color)
    }
}
