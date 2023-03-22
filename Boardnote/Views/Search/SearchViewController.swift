//
//  SearchViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 24/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class SearchViewController: AbstractViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var overlayButton: UIButton!
    lazy var searchBar:UISearchBar = UISearchBar()

    // MARK: - property
    var vmData: SearchViewModelData!
    fileprivate var keyword: String?
    fileprivate var focusIndexPath: IndexPath?
    
    // MARK: - Life cycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.titleView = searchBar
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.titleView = searchBar
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.titleView = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.titleView = nil
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (contexr) in
            self?.updateCollectionView()
        }) { [weak self] (context) in
            self?.updateCollectionView()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - init
    override func initLocalized() {
        super.initLocalized()
        title = LocalizedText.search
    }
    override func initView() {
        super.initView()
        setupSearchBar()
        setupOverlay()
        searchingMode(true)
    }
    override func initCollectionView() {
        super.initCollectionView()
        BookCell.register(with: collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        updateCollectionView()
    }
    
    // MARK: - Helper
    func changeBackTitle(_ title: String) {
        navigationController?.viewControllers.forEach({ (controller) in
            if let controller = controller as? ArchivesViewController {
                controller.title = title
            }
        })
    }
    func searchingMode(_ isSearching: Bool) {
        if isSearching == true {
            overlayButton.isHidden = false
            searchBar.becomeFirstResponder()
        }
        else {
            overlayButton.isHidden = true
            searchBar.resignFirstResponder()
        }
        searchBar.text = keyword
    }
    func clearData() {
        vmData.dataSource = []
        collectionView.reloadData()
        if let layout = self.collectionView.collectionViewLayout as? MMBannerLayout {
            layout.currentIdx = 0
        }
    }
    
    // MARK: - @IBAction
    @IBAction func overlayButtonDidTouch(_ sender: Any) {
        searchingMode(false)
    }
}

//MARK: - Binding UI
extension SearchViewController {
    func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .default
        searchBar.showsCancelButton = true
        searchBar.barTintColor = Appearance.greenColor
        searchBar.tintColor = Appearance.greenColor
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = LocalizedText.search
        searchBar.delegate = self
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.appearanceCornerRadius(12.0, borderColor: UIColor.white)
        textFieldInsideSearchBar?.backgroundColor = UIColor.white
        textFieldInsideSearchBar?.textColor = Appearance.blackColor
        textFieldInsideSearchBar?.font = Appearance.largeFont
        navigationItem.titleView = searchBar
        updateSearchBar()
    }
    func setupOverlay() {
        overlayButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        overlayButton.isHidden = true
    }
    func updateSearchBar() {
//        if let cancelButton: UIButton = self.searchBar.value(forKey: "_cancelButton") as? UIButton{
//            cancelButton.isEnabled = true
//        }
    }
    func updateCollectionView() {
        if let layout = self.collectionView.collectionViewLayout as? MMBannerLayout {
            let gap: CGFloat = 16.0
            let tab: CGFloat = self.tabBarController?.tabBar.frame.size.height ?? 0
            let nav: CGFloat = self.navigationController?.navigationBar.frame.size.height ?? 0
            let status: CGFloat = UIApplication.shared.statusBarFrame.height
            let height: CGFloat = min(Screen.width, Screen.height) - tab - nav - status - (gap * 2.0)
            let width: CGFloat = height * 1 / 1.4142
            let size: CGSize = CGSize(width: width, height: height)
            let itemSpace: CGFloat = max(((Screen.width - width) / 2) - (width / 3.5), (gap * 2))
            layout.itemSpace = itemSpace
            layout.itemSize = size//self.collectionView.frame.insetBy(dx: 40, dy: 40).size
            layout.minimuAlpha = 1.0//0.5
        }
    }
}

//MARK: - Binding Data
extension SearchViewController {
    @objc override func viewModelBindingData() {
        vmData = SearchViewModelData()
        viewModel.data = vmData
        super.viewModelBindingData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension SearchViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeeting
        let cell = BookCell.dequeueReusableCell(with: collectionView, for: indexPath) as! BookCell
        cell.configureCell(dataSource, category: nil)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.focusIndexPath == indexPath {
            let dataSource = self.viewModel.data.dataSource[indexPath.row] as? MMeeting
            let controller = Navigation.bookDetailViewController(meetingId: dataSource?.id, meetingType: dataSource?.type)
            Navigation.pushToViewController(controller, sender: self)
        }
    }
}

// MARK: - BannerLayoutDelegate
extension SearchViewController: BannerLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, focusAt indexPath: IndexPath) {
        focusIndexPath = indexPath
        CLog("Focus At \(indexPath)")
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchingMode(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchingMode(false)
        updateSearchBar()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchingMode(false)
        updateSearchBar()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            keyword = text
            clearData()
            vmData.search(keyword: text)
        }
        searchingMode(false)
        updateSearchBar()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        updateSearchBar()
        return true
    }
}
