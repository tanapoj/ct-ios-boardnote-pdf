//
//  BookCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 16/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class BookCell: CTCollectionViewCell {
    // MARK: - override
    override class var cellId: String { return "BookCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet weak var containerDateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDateLabel: UILabel!
    @IBOutlet weak var dateYearLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func configureCell(_ dataSource: MMeeting?, category: MCategory?) {
        let bookColor = dataSource?.category?.first?.colorDisplay ?? category?.colorDisplay
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        self.bookImageView.backgroundColor = UIColor.clear
        self.bookImageView.image = #imageLiteral(resourceName: "background_book").tintColor(bookColor, backgroundColor: Appearance.contentBackgroundColor)
        
        self.containerDateView.backgroundColor = Appearance.blackColor.withAlphaComponent(0.5)
        self.containerDateView.isHidden = (dataSource?.time == nil)
        self.titleLabel.appearanceBookTitle()
        self.titleLabel.text = dataSource?.title
        
        self.dateMonthLabel.appearanceBookDateSubTitle()
        self.dateDateLabel.appearanceBookDateTitle()
        self.dateYearLabel.appearanceBookDateSubTitle()
        self.dateMonthLabel.text = dataSource?.monthDisplay
        self.dateDateLabel.text = dataSource?.dateDisplay
        self.dateYearLabel.text = dataSource?.yearDisplay
        
        self.locationLabel.appearanceBookSubTitle()
        self.locationLabel.text = dataSource?.locationDisplay
        
        self.timeLabel.appearanceBookSubTitle()
        self.timeLabel.text = dataSource?.timeDisplay
    }
}
