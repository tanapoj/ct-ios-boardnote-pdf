//
//  CheckinViewController.swift
//  Boardnote
//
//  Created by Julapong on 21/5/18.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class CheckinViewController: AbstractViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var checkinLabel: UILabel!
    @IBOutlet private weak var checkinButton: UIButton!
    
    // MARK: - property
    var meeting: MMeeting?
    var vmData: CheckinViewModelData!
    
    // MARK: - init
    override func initLocalized() {
        super.initLocalized()
        descriptionLabel.text = LocalizedText.sentence_checkin_description
        checkinLabel.text = LocalizedText.sentence_checkin_already
        checkinButton.setTitle(normal: LocalizedText.check_in)
    }
    override func initView() {
        super.initView()
        setupView()
    }
    
    // MARK: - Action
    @IBAction func checkinButtonDidTouch(_ sender: Any) {
        Loading.show()
        vmData.onCheckIn()
    }
}

//MARK: - Binding UI
extension CheckinViewController {
    func setupView() {
        userImageView.appearanceCornerRadius()
        titleLabel.appearanceTitle()
        checkinLabel.appearanceTitle()
        checkinLabel.textColor = Appearance.greenColor
        descriptionLabel.appearanceSubTitle()
        checkinButton.appearanceDefault()
        setupView(isHidden: true)
    }
    func setupView(isHidden: Bool) {
        userImageView.isHidden = isHidden
        titleLabel.isHidden = isHidden
        descriptionLabel.isHidden = isHidden
        checkinButton.isHidden = isHidden
        checkinLabel.isHidden = isHidden
    }
    override func updateView() {
        guard let user = vmData.resource as? MUser else { return }
        setupView(isHidden: false)
        titleLabel.text = user.displayName
        userImageView.setImage(urlString: user.avatar)
        checkinButton.appearanceDefault(isEnabled: vmData.inside)
        updateCheckin(user: user)
    }
    func updateCheckin(user: MUser) {
        if user.checkedIn == true {
            checkinButton.isHidden = true
            checkinLabel.isHidden = false
        }
        else {
            checkinButton.isHidden = false
            checkinLabel.isHidden = true
        }
    }
}

//MARK: - Binding Data
extension CheckinViewController {
    @objc override func viewModelBindingData() {
        vmData = CheckinViewModelData(delegate: self, beacons: meeting?.beacons ?? [], meetingId: meeting?.id ?? 0)
        vmData.onCheckInSuccess = onCheckInSuccess()
        vmData.onCheckInFailure = onCheckInFailure()
        viewModel.data = vmData
        super.viewModelBindingData()
    }
    @objc func onCheckInSuccess() -> (() -> Void) {
        return { [weak self] in
            Loading.hide(afterDelay: 0.5, completion: {
                self?.updateView()
            })
        }
    }
    @objc func onCheckInFailure() -> ((_ message: String?) -> Void) {
        return { [weak self] (message) in
            if let strongSelf = self {
                Loading.hide(afterDelay: 0.5, completion: {
                    Alert.errorCheckIn(strongSelf, message: message)
                })
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension CheckinViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        ILog("Failed monitoring region: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ILog("Location manager failed: \(error.localizedDescription)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        vmData.didChangeAuthorization(status: status)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        vmData.didRangeBeacons(beacons: beacons)
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        vmData.didDetermineState(state: state)
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        vmData.didEnterRegion(region: region)
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        vmData.didExitRegion(region: region)
    }
}
