//
//  CalendarCell.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var eventView: UIView!
    
    // MARK: - appearance
    func appearanceBorder() {
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Appearance.lightGreyColor.cgColor
    }
    
    // MARK: - configure
    func configureCell(_ cellState: CellState) {
        self.appearanceBorder()
        self.todayView.appearanceCalendarToday()
        self.eventView.appearanceCornerRadius(self.eventView.frame.width / 2)
        self.eventView.backgroundColor = Appearance.redColor
        self.dateLabel.appearanceCalendarDate(false)
        self.dateLabel.text = cellState.text
        self.selectedView.backgroundColor = Appearance.greenColor.withAlphaComponent(0.3)
        // handle
        self.handleCellSelected(cellState)
        self.handleCellTextColor(cellState)
        //self.handleCellVisibility(cellState)
    }
    
    // MARK: - handle
    func handleCellSelected(_ cellState: CellState){
        self.selectedView.isHidden = true
        /*
        if self.isSelected {
            self.selectedView.isHidden = false
        } else {
            self.selectedView.isHidden = true
        }
         */
    }
    func handleCellTextColor(_ cellState: CellState){
        if cellState.isSelected {
            //self.dateLabel.textColor = Appearance.blackColor
        } else {
            let todayDateStr = Declaration.date.formatter.string(from: Date())
            let cellDateStr = Declaration.date.formatter.string(from: cellState.date)
            self.eventView.backgroundColor = Appearance.redColor
            if todayDateStr == cellDateStr, cellState.dateBelongsTo == .thisMonth {
                self.todayView.isHidden = false
                self.dateLabel.appearanceCalendarDate(true)
            } else {
                self.todayView.isHidden = true
                self.dateLabel.appearanceCalendarDate(false)
                if cellState.dateBelongsTo == .thisMonth {
                    // nothing
                } else { //i.e. case it belongs to inDate or outDate
                    self.dateLabel.textColor = Appearance.greyColor
                    self.eventView.backgroundColor = Appearance.greyColor
                }
            }
        }
    }
    func handleCellVisibility(_ cellState: CellState) {
        self.isHidden = (cellState.dateBelongsTo == .thisMonth) ? false : true
    }
    func handleCellEvents(_ cellState: CellState, eventSource: [MMeeting]?) {
        self.eventView.isHidden = true
        guard let meetings = eventSource, meetings.count > 0 else { return }
        let meeting = meetings.first { (meeting) -> Bool in
            guard let date = meeting.dateCaledar else { return false }
            let cellDate = Declaration.date.formatter.string(from: cellState.date)
            let result: Bool = (date == cellDate)
            //CLog("\(date) == \(cellDate) = \(result)")
            return result
        }
        self.eventView.isHidden = (meeting == nil)
    }
}
