//
//  CTSerializable.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 28/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation

public protocol Serializable: Codable {
    func serialize() -> Data?
}

public extension Serializable {
    public func serialize() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
