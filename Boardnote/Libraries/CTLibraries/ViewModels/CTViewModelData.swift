//
//  CTViewModelData.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 30/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol CTViewInterfaceData: class {
    var dataSource: [Any] { get set }
    var resource: Any? { get set }
    var dataPerPage: Int { get }
    var beginPage: Int { get }
    var currentPage: Int { get set }
    var endOfData: Bool { get set }
    var enableServerLoad: Bool { get }
    var enableLoadMore: Bool { get }
    var isFirstTime: Bool { get set }
    var isLoading: Bool { get set }
    var isUpdateData: Bool { get }
    var heightForHeader: CGFloat { get }
    var heightForRow: CGFloat { get }
    var heightForFooter: CGFloat { get }
    var viewForFooter: UIView? { get }
    var ui:CTViewInterfaceUI? { get set }
    var apiStatus: CTAPIStatus? { get set }
    
    // MARK: - Perform
    func performLoad()
    func cancelLoad()
    
    // MARK: - Local
    func onLocalLoad()
    var onLocalSuccess: ((Any?) -> Void)? { get }
    var onLocalFailure: (() -> Void)? { get set }
    var onLocalCompletion: (() -> Void)? { get set }
    
    // MARK: - Server
    func onServerLoad()
    func onServerLoadMore()
    func onServerRefresh()
    func onServerCancel()
    var onServerSuccess: (CTAPI.onSuccess)? { get }
    var onServerFailure: (CTAPI.onFailure)? { get }
    var onServerCompletion: (CTAPI.onCompletion)? { get set }
}

open class CTViewModelData: CTViewInterfaceData {
    open var dataSource: [Any]
    open var resource: Any?
    open var dataPerPage: Int { return 25 }
    open var beginPage: Int { return 0 }
    open var currentPage: Int
    open var endOfData: Bool
    open var enableServerLoad: Bool { return false }
    open var enableLoadMore: Bool { return true }
    open var isFirstTime: Bool
    open var isLoading: Bool
    open var isUpdateData: Bool { return (currentPage > beginPage) }
    open var heightForHeader: CGFloat { return 8.0 }
    open var heightForRow: CGFloat { return 60.0 }
    open var heightForFooter: CGFloat { return (endOfData) ? 8.0 : 72.0 }
    open var viewForFooter: UIView? {
        if dataSource.count == 0 || endOfData == true { return nil }
        let view:UIActivityIndicatorView = UIActivityIndicatorView (style: .white)
        view.startAnimating()
        view.color = Appearance.primaryColor
        return view
    }
    open var ui: CTViewInterfaceUI?
    open var apiStatus: CTAPIStatus?
    
    // MARK: - init
    public init() {
        dataSource = []
        currentPage = 0
        endOfData = false
        isFirstTime = true
        isLoading = false
    }
    
    // MARK: - Perform
    open func performLoad() {
        if isFirstTime == true {
            onLocalLoad()
            isFirstTime = false
        }
        else {
            onServerLoad()
        }
    }
    open func cancelLoad() {
        if enableServerLoad == false { return }
        onServerCancel()
    }
    
    // MARK: - Local
    open var onLocalSuccess: ((Any?) -> Void)? {
        return { [weak self] (result) in
            guard let dataSource = result as? [Any] else {
                self?.onServerLoad() // server load
                return
            }
            self?.dataSource = dataSource
            if dataSource.count > 0 {
                self?.ui?.hideLoader()
                self?.apiStatus = CTAPIStatus.success
            }
            // server load
            self?.onServerLoad()
        }
    }
    open var onLocalFailure: (() -> Void)?
    open var onLocalCompletion: (() -> Void)?
    open func onLocalLoad() {
        ui?.showLoader()
    }
    
    // MARK: - Server
    open var onServerSuccess: (CTAPI.onSuccess)? {
        return { [weak self] (result, status) in
            // status
            self?.apiStatus = status
            if self?.apiStatus == .dataNotFound {
                self?.ui?.cautionUnit = .dataNotFound
            }
            // data
            if let dataSource = result as? [Any] {
                self?.endOfData = (dataSource.count < (self?.dataPerPage ?? 0))
                // update data
                if self?.isUpdateData == true {
                    self?.dataSource.append(contentsOf: dataSource)
                }
                else if dataSource.count > 0 { // new data
                    self?.dataSource = dataSource
                }
            }
            else if let obj = result {
                self?.resource = obj
            }
        }
    }
    open var onServerFailure: (CTAPI.onFailure)? {
        return { [weak self] (error, status) in
            CLog("code: \(error.code ?? "")\nmessage: \(error.message ?? "")")
            // status
            self?.apiStatus = status
            if self?.apiStatus == .failure {
                self?.ui?.cautionUnit = .retry
            }
            // page
            let page = self?.currentPage ?? 0
            if page > (self?.beginPage ?? 0) {
                self?.currentPage = page - 1
            }
        }
    }
    open var onServerCompletion: (CTAPI.onCompletion)?
    open func onServerLoad() {
        if enableServerLoad == false { return }
        if dataSource.count == 0 { ui?.showLoader() }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        isLoading = true
    }
    open func onServerLoadMore() {
        if enableLoadMore == false { return }
        if endOfData == true || isLoading == true { return }
        currentPage = currentPage + 1
        onServerLoad()
    }
    open func onServerRefresh() {
        if isLoading == true {
            Utility.callback(1.0, { [weak self] in
                self?.ui?.endRefreshing()
            })
            return
        }
        currentPage = beginPage
        Utility.callback(0.3, { [weak self] in
            self?.onServerLoad()
        })
    }
    open func onServerCancel() {
        if enableServerLoad == false { return }
        CLog("onServerCancel: Not implement")
    }
}
