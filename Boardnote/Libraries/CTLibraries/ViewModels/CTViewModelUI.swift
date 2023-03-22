//
//  CTViewModelUI.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 30/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol CTViewInterfaceUI: class {
    var loaderParentView: UIView? { get set }
    
    var cautionParentView: UIView? { get set }
    var cautionUnit: CTCautionView.Unit? { get set }
    var cautionIconImage: UIImage? { get set }
    var cautionDidRetry: (() -> Void)? { get set }
    
    var refreshParentTableView: UITableView? { get set }
    var refreshParentCollectionView: UICollectionView? { get set }
    var refreshDidRefreshControl: ((UIRefreshControl) -> Void)? { get set }
    
    func showLoader()
    func hideLoader()
    
    func showCaution()
    func showCaution(unit: CTCautionView.Unit?)
    func showCaution(unit: CTCautionView.Unit?, icon: UIImage?)
    func hideCaution()
    
    func endRefreshing()
}

open class CTViewModelUI: CTViewInterfaceUI {
    fileprivate var loader: CTLoadingView?
    fileprivate var caution : CTCautionView?
    fileprivate var refreshTableView : UIRefreshControl?
    fileprivate var refreshCollectionView : UIRefreshControl?
    
    open var loaderParentView: UIView? {
        didSet {
            loader = CTLoadingView.instanceFromNib(loaderParentView)
        }
    }
    
    open var cautionParentView: UIView? {
        didSet {
            caution = CTCautionView.instanceFromNib(cautionParentView)
        }
    }
    open var cautionUnit: CTCautionView.Unit? {
        didSet {
            if let unit = cautionUnit {
                caution?.unit = unit
            }
        }
    }
    open var cautionIconImage: UIImage? {
        didSet {
            caution?.iconImage = cautionIconImage
        }
    }
    open var cautionDidRetry: (() -> Void)? {
        didSet {
            caution?.retryButtonDidTouchHandler = cautionDidRetry
        }
    }
    
    open var refreshParentTableView: UITableView? {
        didSet {
            guard let parentView = refreshParentTableView else { return }
            let view = UIRefreshControl()
            view.addTarget(self, action: #selector(self.actionRefreshControlValueDidChange(_:)), for: .valueChanged)
            view.tintColor = Appearance.primaryColor
            self.refreshTableView = view
            parentView.addSubview(view)
        }
    }
    open var refreshParentCollectionView: UICollectionView? {
        didSet {
            guard let parentView = refreshParentCollectionView else { return }
            let view = UIRefreshControl()
            view.addTarget(self, action: #selector(self.actionRefreshControlValueDidChange(_:)), for: .valueChanged)
            view.tintColor = Appearance.primaryColor
            self.refreshCollectionView = view
            parentView.addSubview(view)
        }
    }
    open var refreshDidRefreshControl: ((UIRefreshControl) -> Void)?
    
    
    public init() {
        
    }
    
    open func showLoader() {
        caution?.hide()
        loader?.show()
    }
    open func hideLoader() {
        loader?.hide()
    }
    
    open func showCaution() {
        showCaution(unit: nil)
    }
    open func showCaution(unit: CTCautionView.Unit?) {
        showCaution(unit: unit, icon: nil)
    }
    open func showCaution(unit: CTCautionView.Unit?, icon: UIImage?) {
        caution?.iconImage = icon ?? cautionIconImage
        caution?.unit = unit ?? cautionUnit ?? .retry
        caution?.show()
    }
    open func hideCaution() {
        caution?.hide()
    }
    
    open func endRefreshing() {
        refreshTableView?.endRefreshing()
        refreshCollectionView?.endRefreshing()
    }
    
    // MARK - Action
    @objc private func actionRefreshControlValueDidChange(_ sender: UIRefreshControl) {
        guard let refreshDidRefreshControl = refreshDidRefreshControl else { return }
        refreshDidRefreshControl(sender)
    }
}
