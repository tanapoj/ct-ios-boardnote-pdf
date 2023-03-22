//
//  BookDetailViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 16/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class BookDetailViewController: AbstractViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var containerHeaderView: UIStackView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var headerSubTitleLabel: UILabel!
    
    @IBOutlet private weak var containerMenuView: UIView!
    @IBOutlet private weak var containerMenuViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var menuTableView: UITableView!
    
    @IBOutlet private weak var containerContentView: UIView!
    @IBOutlet private weak var contentTableView: UITableView!
    
    // MARK: - override
    override var rightBarButtonItems: [UIBarButtonItem]? {
        guard let meeting = vmData.meeting else { return nil }
        if meeting.allowCheckin != true { return nil }
        var result: [UIBarButtonItem] = []
        do {
            let button = UIButton.buttonBarAudience(self, action: #selector(self.buttonBarAudienceDidTouch(_:)))
            let barButton = UIBarButtonItem(customView: button)
            result.append(barButton)
        }
        do {
            let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            space.width = 24.0
            result.append(space)
        }
        if Instance.user?.allowCheckin == true {
            let button = UIButton.buttonBarCheckIn(self, action: #selector(self.buttonBarCheckInDidTouch(_:)))
            let barButton = UIBarButtonItem(customView: button)
            result.append(barButton)
        }
        return result
    }
    // MARK: - property
    var meetingType: String?
    var meetingId: Int?
    var vmData: BookDetailViewModelData!
    var isExpandMenu: Bool = true
    var widthMenu: CGFloat {
        if Screen.isTablet == false {
            return 0.0
        }
        return 320.0
    }
    
    // MARK: - init
    override func initView() {
        super.initView()
        setupView()
    }

    // MARK: - Action
    @objc func buttonBarCheckInDidTouch(_ sender: Any) {
        let controller = Navigation.checkinViewController(meeting: vmData.meeting)
        controller.hidesBottomBarWhenPushed = true
        Navigation.pushToViewController(controller, sender: self)
    }
    @objc func buttonBarAudienceDidTouch(_ sender: Any) {
        let controller = Navigation.audienceViewController(meeting: vmData.meeting)
        controller.hidesBottomBarWhenPushed = true
        Navigation.pushToViewController(controller, sender: self)
    }
    func fileButtonDidTouch(_ attachment: MMeetingAttachment) {
        guard let url = attachment.urlString, let filename = attachment.filename, let fileformat = attachment.fileformat else { return }
        CLog("url: \(url)\nfilename: \(filename)\nfileformat: \(fileformat)")
        if fileformat == MMeetingAttachment.FileFormat.image || fileformat == MMeetingAttachment.FileFormat.microsoft {
            let controller = Navigation.quickLookViewController(url, fileName: filename, meetingId: meetingId)
            controller.hidesBottomBarWhenPushed = true
            Navigation.pushToViewController(controller, sender: self)
        }
        else if fileformat == MMeetingAttachment.FileFormat.pdf {
            let controller = Navigation.pdfViewController(url, fileName: filename, meetingId: meetingId)
            controller.hidesBottomBarWhenPushed = true
            Navigation.pushToViewController(controller, sender: self)
        }
    }
}

//MARK: - Binding UI
extension BookDetailViewController {
    func setupView() {
        setupContainerView()
    }
    func setupContainerView() {
        setupContainerHeaderView()
        setupContainerMenuView()
        setupContainerContentView()
        updateContainerView(false)
    }
    func setupContainerHeaderView() {
        containerHeaderView.backgroundColor = UIColor.clear
        headerTitleLabel.appearanceTitle()
        headerSubTitleLabel.appearanceSubTitle()
        headerTitleLabel.text = ""
        headerSubTitleLabel.text = ""
    }
    func setupContainerMenuView() {
        containerMenuView.backgroundColor = UIColor.clear
        menuTableView.scrollsToTop = false
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.separatorColor = UIColor.clear
        menuTableView.backgroundColor = UIColor.clear
        BookDetailMenuCell.register(with: menuTableView)
    }
    func setupContainerContentView() {
        containerContentView.backgroundColor = UIColor.clear
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.separatorStyle = .singleLine
        contentTableView.separatorColor = Appearance.lightGreyColor
        contentTableView.backgroundColor = UIColor.clear
        BookDetailContentCell.register(with: contentTableView)
    }
    
    // MARK: - Update View
    @objc override func updateView() {
        if vmData.meetingType == MCategoryType.news.rawValue {
            updateNewsContainerView()
        }
        if vmData.meetingType == MCategoryType.documentPage.rawValue {
            updateDocumentContainerView()
        }
        headerTitleLabel.text = vmData.meeting?.title
        headerSubTitleLabel.text = vmData.meeting?.locationDisplay
        contentTableView.reloadData()
        menuTableView.reloadData()
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    func updateContainerView(_ animate: Bool = true) {
        let constant: CGFloat = (isExpandMenu == true) ? widthMenu : 0.0
        let duration = (animate) ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.containerMenuViewWidth.constant = constant
            self.view.layoutIfNeeded()
        })
    }
    func updateNewsContainerView() {
        containerMenuViewWidth.constant = 0.0
    }
    func updateDocumentContainerView() {
        containerMenuViewWidth.constant = 0.0
    }
}

//MARK: - Binding Data
extension BookDetailViewController {
    @objc override func viewModelBindingData() {
        vmData = BookDetailViewModelData(meetingId: meetingId, meetingType: meetingType)
        viewModel.data = vmData
        super.viewModelBindingData()
    }
    @objc override func onLocalCompletion() -> (() -> Void) {
        return { [weak self] in
            self?.updateView()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension BookDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == menuTableView {
            return vmData.dataSourceMenu.count
        }
        else if tableView == contentTableView {
            return vmData.dataSource.count
        }
        return 20
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == menuTableView {
            let dataSource = vmData.dataSourceMenu[indexPath.row]
            let cell = BookDetailMenuCell.dequeueReusableCell(with: tableView, for: indexPath) as! BookDetailMenuCell
            cell.configureCellMenu(dataSource, isFocus: (vmData.currentPage == indexPath.row))
            return cell
        }
        else if tableView == contentTableView {
            let dataSource = vmData.dataSource[indexPath.row] as! MMeetingTopic
            let cell = BookDetailContentCell.dequeueReusableCell(with: tableView, for: indexPath) as! BookDetailContentCell
            cell.configureCellContent(dataSource)
            cell.fileButtonDidTouchHandler = { [weak self] (attachment) in
                self?.fileButtonDidTouch(attachment)
            }
            return cell
        }
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableView {
            return 72.0
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == menuTableView {
            return 72.0
        }
        else if tableView == contentTableView {
            return 60
        }
        return Declaration.heightForRow
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == menuTableView {
            vmData.currentPage = indexPath.row
            vmData.reloadData()
            tableView.reloadData()
            contentTableView.reloadData()
            contentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        else if tableView == contentTableView {
            
        }
    }
}
