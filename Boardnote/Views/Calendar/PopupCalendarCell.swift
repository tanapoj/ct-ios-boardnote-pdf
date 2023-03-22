//
//  PopupCalendarCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 09/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class PopupCalendarCell: CTTableViewCell {
    // MARK: - override
    override class var cellId: String { return "PopupCalendarCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - configure
    func configureCell(_ source: MMeeting) {
        self.backgroundColor = UIColor.clear
        self.titleLabel.appearanceCalendarContent()
        self.subtitleLabel.appearanceCalendarTime()
        self.titleLabel.text = source.title
        self.subtitleLabel.text = source.timeDisplay.replacingOccurrences(of: " น.", with: "")
    }
}
