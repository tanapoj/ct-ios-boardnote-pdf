//
//  CTViewModel.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 30/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol CTViewInterface {
    var ui: CTViewInterfaceUI { get set }
    var data: CTViewInterfaceData { get set }
}

open class CTViewModel: CTViewInterface {
    public var ui: CTViewInterfaceUI
    public var data: CTViewInterfaceData
    
    public init(ui: CTViewInterfaceUI = CTViewModelUI(), data: CTViewInterfaceData = CTViewModelData()) {
        self.ui = ui
        self.data = data
    }
}
