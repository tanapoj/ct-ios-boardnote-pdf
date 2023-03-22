//
//  CTCautionView.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class CTCautionView: UIView {

    // MARK: - @IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var bgImageView: UIImageView!
    @IBOutlet private weak var retryButton: UIButton!
    
    public var retryButtonDidTouchHandler: (() -> Void)?
    public var iconImage: UIImage?
    public var unit: Unit = .retry
    private var imageName: String = "retry"
    private let tagCaution: Int = 990002
    private var parentView: UIView?
    
    public enum Unit {
        case retry, dataNotFound
    }
    
    // MARK: - Instance
    open class func instanceFromNib(_ parentView: UIView?) -> CTCautionView {
        let bundle = Assets.bundle()
        let view = UINib(nibName: "CTCautionView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! CTCautionView
        view.parentView = parentView
        view.setup()
        view.initTheme()
        view.initLocalized()
        return view
    }
    
    // MARK: - Setup
    private func setup() {
        let containerView = self.parentView ?? UIApplication.shared.keyWindow?.rootViewController?.view ?? UIView()
        self.tag = self.tagCaution
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        containerView.viewWithTag(self.tagCaution)?.removeFromSuperview()
        containerView.addSubview(self)
        // set constraint
        self.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        // set ui
        self.retryButton.isHidden = true
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }

    // MARK: - init
    @objc open override func initTheme() {
        let image = self.iconImage ?? Assets.image(named: self.imageName)
        self.backgroundColor = UIColor.clear
        self.titleLabel.appearanceCautionTitle()
        self.subTitleLabel.appearanceCautionSubTitle()
        self.retryButton.appearanceCaution()
        self.imageView.image = image?.replaceColor(Appearance.cautionTintColor)
    }
    @objc open override func initLocalized() {
        if self.unit == .retry {
            self.titleLabel.text = LocalizedText.no_data_retry_title
            self.subTitleLabel.text = LocalizedText.no_data_retry_subtitle
            self.retryButton.setTitle(normal: LocalizedText.retry)
        }
        else if self.unit == .dataNotFound {
            self.titleLabel.text = LocalizedText.data_not_found
            self.subTitleLabel.text = nil
        }
    }
    
    // MARK: - Action
    public func show() {
        var imageName:String = "retry"
        var isHidden:Bool = false
        if self.unit == .retry {
            imageName = "retry"
            isHidden = false
        }
        else if self.unit == .dataNotFound {
            imageName = "data_not_found"
            isHidden = true
        }
        self.imageName = imageName
        self.retryButton.isHidden = isHidden
        self.initTheme()
        self.initLocalized()
        self.isHidden = false
    }
    public func hide() {
        self.isHidden = true
    }
    
    // MARK: - @IBAction
    @IBAction private func retryButtonDidTouch(_ sender: Any) {
        if let retryButtonDidTouchHandler = self.retryButtonDidTouchHandler {
            retryButtonDidTouchHandler()
        }
    }

}
