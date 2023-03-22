//
//  UIView+CTExtension.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    // MARK: - init
    @objc public func initTheme() {
        ILog("**** initTheme: not implement ****")
    }
    
    @objc public func initLocalized() {
        ILog("**** initLocalized: not implement ****")
    }
    
    // MARK: - Appearance
    @objc public func appearanceCornerRadius(_ radius: CGFloat = 6.0, borderColor: UIColor? = nil) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if let borderColor = borderColor {
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
        }
        else {
            self.layer.borderWidth = 0
        }
    }
    
    @objc public func appearanceShadow(_ radius: CGFloat = 4.0, color: UIColor = UIColor.black, opacity: Float = 0.25, offset: CGSize = CGSize.zero) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    // MARK: Gradient
    public enum GradientDirection {
        case topToBottom, leftToRight, rightToLeft
    }
    private func gradient(gradientLayer: CAGradientLayer, color: UIColor = UIColor.black, alpha: [CGFloat] = [0.0, 0.2, 0.6]) {
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.2), NSNumber(value: 1.0)]
        var colors: [CGColor] = []
        alpha.forEach { (alpha) in
            colors.append(color.withAlphaComponent(alpha).cgColor)
        }
        gradientLayer.colors = colors
        // remove sublayers
        if let sublayers = self.layer.sublayers {
            sublayers.forEach({ (layer) in
                guard let gradient = layer as? CAGradientLayer else {
                    return
                }
                gradient.removeFromSuperlayer()
            })
        }
        // add layer
        self.layer.addSublayer(gradientLayer)
    }
    public func gradient(direction: GradientDirection = .leftToRight, color: UIColor = UIColor.black, alpha: [CGFloat] = [0.0, 0.2, 0.6]) {
        var startPoint: CGPoint = CGPoint.zero
        var endPoint: CGPoint = CGPoint.zero
        if direction == .topToBottom {
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        else if direction == .leftToRight {
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        else if direction == .rightToLeft {
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.gradient(gradientLayer: gradientLayer, color: color, alpha: alpha)
    }
}
