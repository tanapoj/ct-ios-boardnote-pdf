//
//  URL+CTExtension.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 05/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public extension URL {
    public var absoluteStringByTrimmingQuery: String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}
