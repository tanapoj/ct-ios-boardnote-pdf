//
//  PopupCalendarView.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 09/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class PopupCalendarView: UIView {
    // MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    static let heightForRow: CGFloat = (20.3 * 3.0) // 20.3 equal \n
    static let limitRow: Int = 5
    private var dataSource: [MMeeting]!
    var handler:((MMeeting) -> Void)?
    
    // MARK: - Instance
    class func instanceFromNib(frame: CGRect, source: [MMeeting]) -> PopupCalendarView {
        let view = UINib(nibName: "PopupCalendarView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PopupCalendarView
        view.frame = frame
        view.dataSource = source
        view.initView()
        return view
    }
    
    // MARK: - Setup
    func initView() {
        self.backgroundColor = UIColor.clear
        self.initTableView()
    }
    func initTableView() {
        guard let tableView = self.tableView else { return }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = (self.dataSource.count > PopupCalendarView.limitRow)
        tableView.appearanceDefault()
        PopupCalendarCell.register(with: tableView)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PopupCalendarView : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataSource[indexPath.row]
        let cell = PopupCalendarCell.dequeueReusableCell(with: tableView, for: indexPath) as! PopupCalendarCell
        cell.configureCell(item)
        return cell
    }
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PopupCalendarView.heightForRow
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.dataSource[indexPath.row]
        self.handler?(item)
    }
}
