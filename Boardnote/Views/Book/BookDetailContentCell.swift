//
//  BookDetailContentCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 04/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class BookDetailContentCell: CTTableViewCell {
    // MARK: - override
    override class var cellId: String { return "BookDetailContentCell" }
    
    // MARK: - @IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var containerViewLeft: NSLayoutConstraint!
    
    var dataSource: MMeetingTopic?
    var fileButtonDidTouchHandler: ((_ attachment: MMeetingAttachment) -> Void)?
    
    // MARK: - override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateConstraintCell()
    }
    
    // MARK: - constraint
    func updateConstraintCell() {
        let constant: CGFloat = (self.dataSource?.isSubCategory == true) ? 32.0 : 16.0
        self.containerViewLeft.constant = constant
        self.updateConstraints()
    }
    
    // MARK: - configure
    func configureCellContent(_ dataSource: MMeetingTopic) {
        self.dataSource = dataSource
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.titleLabel.appearanceDocumentContentTitle()
        self.titleLabel.text = dataSource.numberAndTitle
        if dataSource.isCategory == true {
            self.titleLabel.textColor = Appearance.blueColor
        }
        self.configureCellAttachments()
    }
    func configureCellAttachments() {
        //self.containerView.backgroundColor = UIColor.red
        self.containerView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        if let attachments = self.dataSource?.attachments {
            for (index, value) in attachments.enumerated() {
                if value.filename == nil { continue }
                //let priority = UILayoutPriority(UILayoutPriority.defaultHigh.rawValue + Float(index))
                let button = UIButton(type: .custom)
                button.tag = index
                button.backgroundColor = UIColor.clear
                button.titleLabel?.appearanceDocumentContentTitle()
                button.titleLabel?.numberOfLines = 2
                //button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                //button.setContentHuggingPriority(priority, for: UILayoutConstraintAxis.vertical)
                button.contentHorizontalAlignment = .left
                button.addTarget(self, action: #selector(self.fileButtonDidTouch(_:)), for: .touchUpInside)
                button.setTitle(normal: value.filename)
                button.setImage(normal: value.iconImage)
                button.setTitleColor(normal: Appearance.blackColor.withAlphaComponent(0.75))
                button.contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 0)
                button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
                self.containerView.addArrangedSubview(button)
            }
        }
    }
    
    // MARK: - @IBAction
    @objc func fileButtonDidTouch(_ sender: UIButton) {
        ILog("fileButtonDidTouch: \(sender.tag)")
        let index = sender.tag
        if let fileButtonDidTouchHandler = self.fileButtonDidTouchHandler {
            let items = self.dataSource?.attachments ?? []
            if items.count > index {
                let item = items[index]
                fileButtonDidTouchHandler(item)
            }
        }
    }
}
