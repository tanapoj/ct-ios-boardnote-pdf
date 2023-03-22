//
//  CTLoadingView.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class CTLoadingView: UIView {

    // MARK: - @IBOutlet
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let tagLoading: Int = 990001
    private var parentView: UIView?
    // MARK: - Instance
    open class func instanceFromNib(_ parentView: UIView?) -> CTLoadingView {
        let bundle = Assets.bundle()
        let view = UINib(nibName: "CTLoadingView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! CTLoadingView
        view.parentView = parentView
        view.setup()
        view.initTheme()
        return view
    }
    
    // MARK: - Setup
    private func setup() {
        let containerView = self.parentView ?? UIApplication.shared.keyWindow?.rootViewController?.view ?? UIView()
        self.tag = self.tagLoading
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        containerView.viewWithTag(self.tagLoading)?.removeFromSuperview()
        containerView.addSubview(self)
        // set constraint
        let margins = containerView.layoutMarginsGuide
        self.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        // set animating
        self.activityIndicatorView.startAnimating()
    }

    // MARK: - init
    @objc open override func initTheme() {
        self.backgroundColor = UIColor.clear
        self.activityIndicatorView.tintColor = Appearance.primaryColor
        self.activityIndicatorView.color = Appearance.primaryColor
    }
    @objc open override func initLocalized() {
        
    }
    
    // MARK: - Action
    public func show() {
        self.initTheme()
        self.initLocalized()
        self.isHidden = false
    }
    public func hide() {
        self.isHidden = true
    }
}
