//
//  AboutUsViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 26/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.appearanceCornerRadius(20.0)
        titleLabel.appearanceTitle()
        titleLabel.text = "MD iNote เวอร์ชั่น \(Application.version)"
        
        let tappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tappedRecognizer.numberOfTapsRequired = 9
        view.addGestureRecognizer(tappedRecognizer)
    }
    
    @objc func tapped() {
        guard let deviceToken = Instance.deviceToken else { return }
        Alert.base(self, title: "Device token", message: deviceToken, buttonOk: "OK")
    }
    
}
