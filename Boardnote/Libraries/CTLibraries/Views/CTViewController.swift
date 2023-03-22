//
//  CTViewController.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 18/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

open class CTViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var tableView: UITableView!
    
    open var leftBarButtonItems: [UIBarButtonItem]? { return nil }
    open var leftButtonBar: UIButton?
    open var rightBarButtonItems: [UIBarButtonItem]? { return nil }
    open var rightButtonBar: UIButton?

    open lazy var viewModel: CTViewInterface = CTViewModel()
    
    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return Appearance.statusBarStyle
    }

    // MARK: - Life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initTheme()
        initLocalized()
        initViewModel()
        initView()
        initTableView()
        initCollectionView()
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.data.performLoad()
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.data.cancelLoad()
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        CLog("******* deinit: \(Utility.nameOfClass(self)) *******")
    }

    // MARK: - init
    open func initialize() {
        
    }
    @objc open override func initTheme() {
        self.view.backgroundColor = Appearance.contentBackgroundColor
        self.setNeedsStatusBarAppearanceUpdate()
    }
    @objc open override func initLocalized() {
        
    }
    open func initViewModel() {
        viewModelBindingUI()
        viewModelBindingData()
    }
    open func initView() {
        self.navigationItem.leftBarButtonItems = self.leftBarButtonItems
        self.navigationItem.rightBarButtonItems = self.rightBarButtonItems
    }
    open func initTableView() {
        guard let tableView = self.tableView else { return }
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
    }
    open func initCollectionView() {
        guard let collectionView = self.collectionView else { return }
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Action
    @objc open override func actionLeftBarButtonDidTouch(_ sender: Any) {
        ILog("**** actionLeftBarButtonDidTouch: not implement ****")
    }
    @objc open override func actionRightBarButtonDidTouch(_ sender: Any) {
        ILog("**** actionRightBarButtonDidTouch: not implement ****")
    }
}

//MARK: - Binding UI
extension CTViewController {
    @objc open func viewModelBindingUI() {
        viewModel.ui.loaderParentView = view
        viewModel.ui.cautionParentView = view
        viewModel.ui.cautionUnit = nil
        viewModel.ui.cautionIconImage = nil
        viewModel.ui.cautionDidRetry = cautionDidRetry()
        viewModel.ui.refreshParentTableView = tableView
        viewModel.ui.refreshParentCollectionView = collectionView
        viewModel.ui.refreshDidRefreshControl = refreshDidRefreshControl()
    }
    @objc open func updateView() {
        if let tableView = self.tableView { tableView.reloadData() }
        if let collectionView = self.collectionView { collectionView.reloadData() }
    }
    @objc open func updateViewFailure() {
        CLog("updateViewFailure: Not implement")
    }
    @objc open func cautionDidRetry() -> (() -> Void) {
        return { [weak self] in
            self?.viewModel.data.onServerLoad()
        }
    }
    @objc open func refreshDidRefreshControl() -> ((_ sender: UIRefreshControl) -> Void)? {
        return { [weak self] (sender) in
            self?.viewModel.data.onServerRefresh()
        }
    }
}

//MARK: - Binding Data
extension CTViewController {
    @objc open func viewModelBindingData() {
        viewModel.data.ui = viewModel.ui
        viewModel.data.onLocalCompletion = onLocalCompletion()
        viewModel.data.onLocalFailure = onLocalFailure()
        viewModel.data.onServerCompletion = onServerCompletion()
    }
    @objc open func onLocalCompletion() -> (() -> Void) {
        return { [weak self] in
            self?.updateView()
        }
    }
    @objc open func onLocalFailure() -> (() -> Void) {
        return { [weak self] in
            self?.updateViewFailure()
        }
    }
    @objc open func onServerCompletion() -> (CTAPI.onCompletion) {
        return { [weak self] in
            // update ui
            self?.viewModel.ui.hideLoader()
            self?.viewModel.ui.hideCaution()
            self?.viewModel.ui.endRefreshing()
            if self?.viewModel.data.dataSource.count == 0, self?.viewModel.data.resource == nil {
                self?.viewModel.ui.showCaution()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            // update data
            self?.viewModel.data.isLoading = false
            self?.updateView()
        }
    }
}

// MARK: - Scroll view & Load more
extension CTViewController {
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // load more
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.size.height) {
            self.viewModel.data.onServerLoadMore()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CTViewController : UITableViewDataSource, UITableViewDelegate {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.data.dataSource.count
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.red
        return cell
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.viewModel.data.viewForFooter
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.viewModel.data.heightForHeader
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.data.heightForRow
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.viewModel.data.heightForFooter
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CTViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.data.dataSource.count
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.red
        return cell
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ILog("didSelectItemAt: Not implement - \(indexPath)")
    }
}
