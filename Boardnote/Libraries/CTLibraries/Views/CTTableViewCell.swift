//
//  CTTableViewCell.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 24/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

public protocol CTTableViewCellInterface {
    static var cellId: String { get }
    static var bundle: Bundle { get }
    static var nib: UINib { get }
    
    static func register(with tableView: UITableView)
    static func dequeueReusableCell(with tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

open class CTTableViewCell: UITableViewCell, CTTableViewCellInterface {
    open class var cellId: String { return "CTTableViewCell" }
    open class var bundle: Bundle { return Bundle(for: self) }
    open class var nib: UINib { return UINib(nibName: cellId, bundle: bundle) }
    
    open class func register(with tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    open class func dequeueReusableCell(with tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
    
    open func setSelectedBackgroundPrimaryColor() {
        let view = UIView()
        view.backgroundColor = Appearance.primaryColor.withAlphaComponent(0.25)
        selectedBackgroundView = view
    }
    open func setSelectedBackgroundBlankColor() {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        selectedBackgroundView = view
    }
}
