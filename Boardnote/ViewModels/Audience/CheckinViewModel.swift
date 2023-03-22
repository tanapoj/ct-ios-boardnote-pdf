//
//  CheckinViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta
import CoreLocation

class CheckinViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var enableLoadMore: Bool { return false }
    
    let locationManager = CLLocationManager()
    var beacons: [MBeacon]!
    var meetingId: Int!
    var inside: Bool = false
    var status: CLAuthorizationStatus?
    var onCheckInFailure: ((_ message: String?) -> Void)?
    var onCheckInSuccess: (() -> Void)?
    
    override init() {
        super.init()
    }
    init(delegate: CLLocationManagerDelegate?, beacons: [MBeacon], meetingId: Int) {
        super.init()
        self.beacons = beacons
        self.meetingId = meetingId
        locationManager.delegate = delegate
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
    }
    
    override func onLocalLoad() {
        onLocalSuccess?(nil)
        onLocalCompletion?()
    }
    
    override func onServerLoad() {
        super.onServerLoad()
        API.meAttendances(meetingId: meetingId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: { [weak self] in
            self?.initLocation()
        })
    }
    
    override func onServerCancel() {
        API.cancelAttendances()
    }
    
    func onCheckIn() {
        API.postAttendances(meetingId, onSuccess: { [weak self] in
            if let user = self?.resource as? MUser {
                user.checkedIn = true
                self?.resource = user
            }
            self?.onCheckInSuccess?()
        }, onFailure: { [weak self] (error, status) in
            self?.onCheckInFailure?(error.message ?? "")
        })
    }
    
    func initLocation() {
        guard let user = resource as? MUser else { return }
        if (status == .authorizedAlways || status == .authorizedWhenInUse), beacons.count > 0 {
            CLog("startMonitoring")
            if user.checkedIn == true {
                startMonitoring()
            }
            else {
                startMonitoring()
            }
        }
        else { // if status == .denied || beacons.count == 0 {
            CLog("Authorization: denied OR beacons not found")
            stopMonitoring()
        }
        updateLocation()
    }
    func updateLocation() {
        self.onServerCompletion?()
    }
    
    // MARK: - monitoring
    func startMonitoring() {
        beacons.forEach { (beacon) in
            startMonitoringBeacon(beacon)
        }
    }
    func stopMonitoring() {
        beacons.forEach { (beacon) in
            stopMonitoringBeacon(beacon)
        }
    }
    func startMonitoringBeacon(_ beacon: MBeacon) {
        guard let beaconRegion = beacon.asBeaconRegion() else { return }
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func stopMonitoringBeacon(_ beacon: MBeacon) {
        guard let beaconRegion = beacon.asBeaconRegion() else { return }
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    // MARK: - CLLocationManagerDelegate
    func didChangeAuthorization(status: CLAuthorizationStatus) {
        CLog("didChangeAuthorization: \(status.rawValue)")
        self.status = status
        self.initLocation()
    }
    func didRangeBeacons(beacons: [CLBeacon]) {
        //CLog("didRangeBeacons: \(beacons)")
        for beacon in beacons {
            for index in 0..<self.beacons.count {
                if self.beacons[index] == beacon {
                    self.beacons[index].beacon = beacon
                    //CLog(self.beacons[index].debugDescription)
                }
            }
        }
    }
    func didDetermineState(state: CLRegionState) {
        if state == CLRegionState.inside {
            ILog("inside")
            inside = true
            updateLocation()
        }
        else {
            ILog("outside")
            inside = false
        }
    }
    func didEnterRegion(region: CLRegion) {
        ILog("enter")
    }
    func didExitRegion(region: CLRegion) {
        ILog("exit")
    }
}
