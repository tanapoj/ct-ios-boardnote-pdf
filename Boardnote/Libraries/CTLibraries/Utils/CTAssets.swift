//
//  CTAssets.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 20/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class Assets: NSObject {
    internal static func bundle() -> Bundle {
        let bundle = Bundle(for: Assets.self)
        return bundle
    }
    
    public static func path(forResource: String, ofType: String) -> String? {
        let bundle = Assets.bundle()
        return bundle.path(forResource: forResource, ofType: ofType)
    }
    
    public static func image(named: String) -> UIImage? {
        let bundle = Assets.bundle()
        let image = UIImage(named: named, in: bundle, compatibleWith: nil)
        return image
    }
}
