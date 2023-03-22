//
//  UIImageExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func tintColor(_ color:UIColor?, backgroundColor: UIColor = UIColor.white) -> UIImage? {
        let rect = CGRect(origin: .zero, size: self.size)
        let color = color ?? UIColor.gray
        
        //image colored
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //image multiply
        UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        // fill the background with white so that translucent colors get lighter
        context!.setFillColor(backgroundColor.cgColor)
        context!.fill(rect)
        
        self.draw(in: rect, blendMode: .normal, alpha: 1)
        coloredImage?.draw(in: rect, blendMode: .overlay, alpha: 1)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
