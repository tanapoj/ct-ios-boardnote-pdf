//
//  CalendarViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: AbstractViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var containerCalendarView: UIView!
    @IBOutlet private weak var calendarView: JTAppleCalendarView!
    @IBOutlet private weak var dayLabel1: UILabel!
    @IBOutlet private weak var dayLabel2: UILabel!
    @IBOutlet private weak var dayLabel3: UILabel!
    @IBOutlet private weak var dayLabel4: UILabel!
    @IBOutlet private weak var dayLabel5: UILabel!
    @IBOutlet private weak var dayLabel6: UILabel!
    @IBOutlet private weak var dayLabel7: UILabel!
    
    // MARK: - property
    fileprivate var month: String = ""
    fileprivate var year: String = ""
    var meetingTime: String? {
        didSet {
            if let dateTime = meetingTime {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy HH:mm"
                formatter.calendar = Declaration.date.calendar
                if let date = formatter.date(from: dateTime) {
                    self.calendarView.reloadData()
                    self.scrollToToDate(date)
                }
            }
        }
    }
    
    // MARK: - override
    override var rightBarButtonItems: [UIBarButtonItem]? {
        let button = UIButton.buttonBarText(LocalizedText.today, target: self, action: #selector(self.actionRightBarButtonDidTouch(_:)))
        self.rightButtonBar = button
        let barButton = UIBarButtonItem(customView: button)
        return [barButton]
    }

    // MARK: - Life cycle
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.calendarView.reloadData()
        self.initCalendarLabel(size)
        self.scrollToToday(false)
    }

    // MARK: - init
    override func initView() {
        super.initView()
        self.initCalendarView()
    }
    func initTitleView() {
        let label = UILabel()
        label.font = Appearance.extraLargeFontBold
        label.textColor = Appearance.whiteColor
        label.text = "\(self.month) \(self.year)"
        label.textAlignment = .center
        label.sizeToFit()
        self.navigationItem.titleView = label
    }
    func initCalendarView() {
        self.containerCalendarView.backgroundColor = UIColor.clear
        self.calendarView.calendarDataSource = self
        self.calendarView.calendarDelegate = self
        self.calendarView.minimumLineSpacing = 0
        self.calendarView.minimumInteritemSpacing = 0
        self.calendarView.visibleDates { (visibleDates) in
            self.initCalendarTitle(visibleDates)
        }
        self.scrollToToday(false)
        self.initCalendarLabel(Screen.size)
    }
    func initCalendarTitle(_ visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        self.year = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        self.month = formatter.string(from: date)
        self.initTitleView()
    }
    func initCalendarLabel(_ size: CGSize) {
        self.dayLabel1.appearanceCalendarDay(.sunday, screenSize: size)
        self.dayLabel2.appearanceCalendarDay(.monday, screenSize: size)
        self.dayLabel3.appearanceCalendarDay(.tuesday, screenSize: size)
        self.dayLabel4.appearanceCalendarDay(.wednesday, screenSize: size)
        self.dayLabel5.appearanceCalendarDay(.thursday, screenSize: size)
        self.dayLabel6.appearanceCalendarDay(.friday, screenSize: size)
        self.dayLabel7.appearanceCalendarDay(.saturday, screenSize: size)
    }

    // MARK: - Action
    @objc override func actionRightBarButtonDidTouch(_ sender: Any) {
        self.scrollToToday()
    }
    func scrollToToday(_ animateScroll: Bool = true) {
        self.scrollToToDate(Date(), animateScroll: animateScroll)
    }
    func scrollToToDate(_ date: Date, animateScroll: Bool = true) {
        self.calendarView.scrollToDate(date, animateScroll: animateScroll)
    }
}

//MARK: - Binding UI
extension CalendarViewController {
    // MARK: - update
    override func updateView() {
        self.calendarView.reloadData()
    }
}

//MARK: - Binding Data
extension CalendarViewController {
    @objc override func viewModelBindingData() {
        self.viewModel.data = CalendarViewModelData()
        super.viewModelBindingData()
    }
}

// MARK: - JTAppleCalendarViewDataSource & JTAppleCalendarViewDelegate
extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let calendar = Declaration.date.calendar
        let startDate = Declaration.date.start
        let endDate = Declaration.date.end
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, calendar: calendar)
        return parameters
    }
}
extension CalendarViewController: JTAppleCalendarViewDelegate {
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.configureCell(cellState)
        cell.handleCellEvents(cellState, eventSource: self.viewModel.data.dataSource as? [MMeeting])
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        cell.configureCell(cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
//        validCell.configureCell(cellState)
        //print("\(cellState.dateBelongsTo): \(Declaration.date.formatter.string(from: cellState.date))")
        //Navigation.pushTo(.pdf, sender: self)
        
        guard let dataSource = self.viewModel.data.dataSource as? [MMeeting] else { return }
        let filter = dataSource.filter { (meeting) -> Bool in
            guard let date = meeting.dateCaledar else { return false }
            return (date == Declaration.date.formatter.string(from: cellState.date))
        }
        if filter.count == 0 { return }
        
        Alert.calendar(self, sourceView: self.calendarView, sourceRect: validCell.frame, sourceData: filter)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
//        guard let validCell = cell as? CalendarCell else { return }
//        validCell.configureCell(cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.initCalendarTitle(visibleDates)
    }
}
