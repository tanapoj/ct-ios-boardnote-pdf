//
//  MBeacon.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 20/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class MBeacon: CTModel {
    var id: Int?
    var uuid: String?
    var identifier: String?
    var major: String?
    var minor: String?
    var beacon: CLBeacon?
    
    override var debugDescription: String {
        return "uuid: \(uuid ?? "")\nlocation: \(locationString())\nmajor: \(major ?? "")\nminor: \(minor ?? "")\nidentifier: \(identifier ?? "")"
    }
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        id          <- map["id"]
        uuid        <- map["uuid"]
        identifier  <- map["identifier"]
        major       <- map["major"]
        minor       <- map["minor"]
    }
    
    // MARK: - Helper
    func asBeaconRegion() -> CLBeaconRegion? {
        guard let uuidString = self.uuid, let majorString = self.major, let minorString = self.minor, let identifier = self.identifier else { return nil }
        guard let uuid = UUID(uuidString: uuidString) else { return nil }
        let major: CLBeaconMajorValue = CLBeaconMajorValue(Int(majorString) ?? 0)
        let minor: CLBeaconMinorValue = CLBeaconMinorValue(Int(minorString) ?? 0)
        return CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "\(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        return location
    }

    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
}

func ==(item: MBeacon, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == (item.uuid ?? ""))
        && (Int(truncating: beacon.major) == Int((item.major ?? "0")))
        && (Int(truncating: beacon.minor) == Int((item.minor ?? "0"))))
}
