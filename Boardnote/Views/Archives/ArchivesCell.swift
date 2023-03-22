//
//  ArchivesCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 17/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class ArchivesCell: CTCollectionViewCell {
    // MARK: - override
    override class var cellId: String { return "ArchivesCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(_ dataSource: MMeetingArchive?) {
        self.containerView.backgroundColor = Appearance.greenColor
        self.containerView.appearanceCornerRadius()
        self.titleLabel.appearanceTitleWhite()
        self.titleLabel.text = dataSource?.title
    }
}
