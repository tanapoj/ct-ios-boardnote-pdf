//
//  UILabelExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // MARK: Appearance
    func appearanceTitle() {
        self.textColor = Appearance.blackColor
        self.font = Appearance.extraLargeFont
        self.numberOfLines = 0
    }
    func appearanceTitleWhite() {
        self.textColor = UIColor.white
        self.font = Appearance.extraLargeFont
        self.numberOfLines = 0
    }
    func appearanceSubTitle() {
        self.textColor = Appearance.lightBlackColor
        self.font = Appearance.extraMediumFont
        self.numberOfLines = 0
    }
    func appearanceContent() {
        self.textColor = Appearance.blackColor
        self.font = Appearance.mediumFont
        self.numberOfLines = 0
    }
    
    // MARK: Appearance - Book
    func appearanceBookDefault(_ ofSize: CGFloat = 21.0) {
        self.textColor = UIColor.white.withAlphaComponent(0.75)
        self.numberOfLines = 0
        self.font = UIFont.boldSystemFont(ofSize: ofSize)
    }
    func appearanceBookTitle() {
        let fontSize: CGFloat = (Screen.isTablet == true) ? 36.0 : 18.0
        self.appearanceBookDefault(fontSize)
        self.numberOfLines = 4
    }
    func appearanceBookSubTitle() {
        let fontSize: CGFloat = (Screen.isTablet == true) ? 24.0 : 12.0
        self.appearanceBookDefault(fontSize)
        self.numberOfLines = 4
    }
    func appearanceBookDateTitle() {
        let fontSize: CGFloat = (Screen.isTablet == true) ? 48.0 : 16.0
        self.appearanceBookDefault(fontSize)
        self.numberOfLines = 1
    }
    func appearanceBookDateSubTitle() {
        let fontSize: CGFloat = (Screen.isTablet == true) ? 24.0 : 12.0
        self.appearanceBookDefault(fontSize)
        self.numberOfLines = 1
    }
    
    // MARK: Appearance - Document
    func appearanceDocumentContentTitle(_ isFocus: Bool = true) {
        let size: CGFloat = (isFocus == true) ? 17 : 14
        self.textColor = Appearance.blackColor
        self.font = UIFont.systemFont(ofSize: size)
        self.numberOfLines = 0
    }
    func appearanceDocumentMenuTitle(_ isFocus: Bool = true) {
        let size: CGFloat = (isFocus == true) ? 17 : 14
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: size)
        self.numberOfLines = 2
    }
    func appearanceDocumentMenuNumberTitle(_ isFocus: Bool = true) {
        let size: CGFloat = (isFocus == true) ? 17 : 14
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: size)
        self.numberOfLines = 2
    }
    func appearanceDocumentMenuNumberValue(_ isFocus: Bool = true) {
        let size: CGFloat = (isFocus == true) ? 21 : 17
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: size)
        self.numberOfLines = 2
    }
    // MARK: Appearance - Calendar
    func appearanceCalendarDate(_ isToday: Bool) {
        self.textColor = (isToday) ? UIColor.white : Appearance.blackColor
        self.font = (isToday) ? Appearance.largeFontBold : Appearance.largeFont
        self.numberOfLines = 0
    }
    func appearanceCalendarDay(_ dayOfWeek: Declaration.DayOfWeek, screenSize: CGSize) {
        self.backgroundColor = Appearance.lightGreyColor
        self.textColor = Appearance.blackColor
        self.font = Appearance.mediumFont
        self.numberOfLines = 1
        self.adjustsFontSizeToFitWidth = true
        var text = ""
        switch dayOfWeek {
        case .sunday:       text = Declaration.symbol.dayOfWeek.sunday(screenSize)
        case .monday:       text = Declaration.symbol.dayOfWeek.monday(screenSize)
        case .tuesday:      text = Declaration.symbol.dayOfWeek.tuesday(screenSize)
        case .wednesday:    text = Declaration.symbol.dayOfWeek.wednesday(screenSize)
        case .thursday:     text = Declaration.symbol.dayOfWeek.thursday(screenSize)
        case .friday:       text = Declaration.symbol.dayOfWeek.friday(screenSize)
        case .saturday:     text = Declaration.symbol.dayOfWeek.saturday(screenSize)
        }
        self.text = text
    }
    func appearanceCalendarContent() {
        self.textColor = Appearance.blackColor
        self.font = Appearance.mediumFont
        self.numberOfLines = 2
    }
    func appearanceCalendarTime() {
        self.textColor = Appearance.greenColor
        self.font = Appearance.extraMediumFontBold
        self.numberOfLines = 1
    }
    
    /*
    
    func appearanceContentWhite() {
        self.textColor = UIColor.white
        self.font = Appearance.contentFont
        self.numberOfLines = 0
    }
    func appearanceCautionTitle() {
        self.textColor = Appearance.blackColor
        self.font = Appearance.titleFontBold
        self.numberOfLines = 0
    }
    func appearanceCautionSubTitle() {
        self.textColor = Appearance.blackColor
        self.font = Appearance.contentFont
        self.numberOfLines = 0
    }
    
    
    
    
    
    
 */
}
