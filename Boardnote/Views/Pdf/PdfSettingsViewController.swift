//
//  PdfSettingsViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 01/06/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol PdfSettingsViewControllerDelegate {
    func pdfSettingsViewControllerDidUpdateViewMode(_ sender: PdfSettingsViewController)
    func pdfSettingsViewControllerDidToggleNightMode(_ sender: PdfSettingsViewController)
    func pdfSettingsViewControllerDidCompleted()
}

class PdfSettingsViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - property
    fileprivate var leftBarButtonItems: [UIBarButtonItem]? { return nil }
    fileprivate var rightBarButtonItems: [UIBarButtonItem]? {
        let button = UIButton.buttonBarText(LocalizedText.done, target: self, action: #selector(self.rightBarButtonDidTouch(_:)))
        let barButton = UIBarButtonItem(customView: button)
        return [barButton]
    }
    fileprivate var KEY_ITEMS = "items"
    fileprivate var KEY_TITLE = "title"
    fileprivate var KEY_IMAGE = "image"
    fileprivate var KEY_MODE = "mode"
    fileprivate var dataSource: [[String:Any]] = []
    
    var delegate: PdfSettingsViewControllerDelegate?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
        self.setupLocalized()
        self.setupBarButtonLeft()
        self.setupBarButtonRight()
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        CLog("******* deinit: \(Utility.nameOfClass(self)) *******")
    }
    
    // MARK: - initialize
    func initialize() {
        self.dataSource = []
        do { // view mode
            let items: [[String:Any]] = [
                [KEY_TITLE: LocalizedText.view_mode_singlepage, KEY_IMAGE: #imageLiteral(resourceName: "ic_view_mode_single_black_24px"), KEY_MODE: PDFSettings.ViewMode.singlePage],
                [KEY_TITLE: LocalizedText.view_mode_continuous, KEY_IMAGE: #imageLiteral(resourceName: "ic_view_mode_continuous_black_24px"), KEY_MODE: PDFSettings.ViewMode.continuous],
                [KEY_TITLE: LocalizedText.view_mode_facing, KEY_IMAGE: #imageLiteral(resourceName: "ic_view_mode_facing_black_24px"), KEY_MODE: PDFSettings.ViewMode.facing],
                [KEY_TITLE: LocalizedText.view_mode_coverfacing, KEY_IMAGE: #imageLiteral(resourceName: "ic_view_mode_cover_black_24px"), KEY_MODE: PDFSettings.ViewMode.coverFacing],
            ]
            let source: [String:Any] = [
                KEY_TITLE: LocalizedText.view_mode,
                KEY_ITEMS: items
            ]
            self.dataSource.append(source)
        }
        do { // night mode
            let items: [[String:Any]] = [
                [KEY_TITLE: LocalizedText.night_mode, KEY_IMAGE: #imageLiteral(resourceName: "ic_mode_night_black_24px")],
                ]
            let source: [String:Any] = [
                KEY_TITLE: LocalizedText.night_mode,
                KEY_ITEMS: items
            ]
            self.dataSource.append(source)
        }
    }
    
    // MARK: - Setup Localized
    func setupLocalized() {
        self.title = LocalizedText.settings
    }
    
    // MARK: - Setup BarButton
    func setupBarButtonLeft() {
        self.navigationItem.leftBarButtonItems = self.leftBarButtonItems
    }
    func setupBarButtonRight() {
        self.navigationItem.rightBarButtonItems = self.rightBarButtonItems
    }
    @objc func leftBarButtonDidTouch(_ sender: Any) {
        ILog("not implement")
    }
    @objc func rightBarButtonDidTouch(_ sender: Any) {
        self.delegate?.pdfSettingsViewControllerDidCompleted()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup View
    func setupView() {
        self.setupTableView()
    }
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
    }
}


// MARK: - UITableViewDataSource & UITableViewDelegate
extension PdfSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = self.dataSource[section]
        let items = dataSource[KEY_ITEMS] as! [Any]
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = self.dataSource[indexPath.section]
        let title = dataSource[KEY_TITLE] as? String ?? ""
        let items = dataSource[KEY_ITEMS] as! [Any]
        let item = items[indexPath.row] as! [String:Any]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = item[KEY_IMAGE] as? UIImage
        cell.textLabel?.text = item[KEY_TITLE] as? String
        cell.accessoryType = .none
        if title == LocalizedText.view_mode {
            if PDF.shared.settings.viewMode == (item[KEY_MODE] as! PDFSettings.ViewMode) {
                cell.accessoryType = .checkmark
            }
        }
        else if (title == LocalizedText.night_mode && PDF.shared.settings.nightMode == .night) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}
extension PdfSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataSource = self.dataSource[section]
        let title = dataSource[KEY_TITLE] as? String ?? ""
        return title
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataSource = self.dataSource[indexPath.section]
        let title = dataSource[KEY_TITLE] as? String ?? ""
        if title == LocalizedText.view_mode {
            let items = dataSource[KEY_ITEMS] as! [Any]
            let item = items[indexPath.row] as! [String:Any]
            PDF.shared.settings.viewMode = item[KEY_MODE] as! PDFSettings.ViewMode
            // send delegate
            self.delegate?.pdfSettingsViewControllerDidUpdateViewMode(self)
            // save
            Cache.save(key: CacheKey.pdfSettings, object: PDF.shared.settings.source())
            // reload
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        else if title == LocalizedText.night_mode {
            PDF.shared.settings.nightMode = (PDF.shared.settings.nightMode == .normal) ? .night : .normal
            // send delegate
            self.delegate?.pdfSettingsViewControllerDidToggleNightMode(self)
            // save
            Cache.save(key: CacheKey.pdfSettings, object: PDF.shared.settings.source())
            // reload
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
