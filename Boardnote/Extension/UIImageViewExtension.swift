//
//  UIImageViewExtension.swift
//  Boardnote
//
//  Created by Julapong on 3/6/18.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    // MARK: - Image
    func setImage(urlString: String? = nil, placeholder: UIImage? = #imageLiteral(resourceName: "placeholder_image"), completionHandler: (() -> Void)? = nil) {
        clipsToBounds = true
        contentMode = .scaleAspectFill
        let placeholderImage: UIImage? = placeholder
        guard let string = urlString else {
            image = placeholderImage
            completionHandler?()
            return
        }
        guard let url = URL(string: string) else {
            image = placeholderImage
            completionHandler?()
            return
        }
        kf.setImage(with: url, placeholder: placeholderImage, completionHandler: { (image, error, cacheType, url) in
            completionHandler?()
        })
    }
}
