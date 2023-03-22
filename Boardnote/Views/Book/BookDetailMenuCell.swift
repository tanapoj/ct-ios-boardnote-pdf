//
//  BookDetailMenuCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 04/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class BookDetailMenuCell: CTTableViewCell {
    // MARK: - override
    override class var cellId: String { return "BookDetailMenuCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var containerViewRight: NSLayoutConstraint!
    @IBOutlet private weak var containerLeftImageView: UIImageView!
    @IBOutlet private weak var containerRightImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberTitleLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    var isFocus: Bool?

    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateConstraintCell()
    }
    
    // MARK: - constraint
    func updateConstraintCell() {
        let constantHeight: CGFloat = (self.isFocus == true) ? 72.0 : 60.0
        let constantRight: CGFloat = (self.isFocus == true) ? 16.0 : 56.0
        self.containerViewHeight.constant = constantHeight
        self.containerViewRight.constant = constantRight
    }
    
    // MARK: - configure
    func configureCellMenu(_ dataSource: MMeetingTopic, isFocus: Bool) {
        self.selectionStyle = .none
        self.isFocus = isFocus
        self.containerView.backgroundColor = UIColor.clear
        self.containerLeftImageView.backgroundColor = Appearance.greenColor
        self.containerRightImageView.image = #imageLiteral(resourceName: "background_arrow").replaceColor(Appearance.greenColor)
        self.titleLabel.appearanceDocumentMenuTitle(isFocus)
        self.numberLabel.appearanceDocumentMenuNumberValue(isFocus)
        self.numberTitleLabel.appearanceDocumentMenuNumberTitle(isFocus)
        
        self.titleLabel.text = dataSource.title
        self.numberLabel.text = ""
        self.numberTitleLabel.text = ""
        if let number = dataSource.number {
            self.numberLabel.text = number
            self.numberTitleLabel.text = LocalizedText.number_title
        }
    }
}
