//
//  LoadingHelper.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
//import PKHUD

class Loading {
    
    static func hide(afterDelay: TimeInterval = 0.0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            HUD.hide(afterDelay: afterDelay, completion: { (completed) in
                DispatchQueue.main.async {
                    if let completion = completion {
                        completion()
                    }
                }
            })
        }
    }
    static func show() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }
    static func success(completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            HUD.flash(.success, delay: 1.0, completion: { (completed) in
                DispatchQueue.main.async {
                    if let completion = completion {
                        completion()
                    }
                }
            })
        }
    }
}
