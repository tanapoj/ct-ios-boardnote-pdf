//
//  DeclarationHelper.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Declaration {
    enum DayOfWeek {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }
    // MARK: - date
    struct date {
        static var calendar: Calendar = {
            return Calendar(identifier: .gregorian)
        }()
        static var start: Date {
            var now = Date()
            var nowComponents = DateComponents()
            let calendar = Declaration.date.calendar
            let month = calendar.component(.month, from: now)
            if month < 6 {
                now = calendar.date(byAdding: .month, value: -6, to: now)!
            }
            else {
                nowComponents.year = calendar.component(.year, from: now)
                nowComponents.month = 1
                nowComponents.day = 1
                nowComponents.hour = 0
                nowComponents.minute = 0
                nowComponents.second = 0
                nowComponents.timeZone = calendar.timeZone
                now = calendar.date(from: nowComponents)!
            }
            return now as Date
        }
        static var end: Date {
            return Declaration.date.calendar.date(byAdding: .month, value: 6, to: Date())!
        }
        static var formatter: DateFormatter = {
            let calendar = Declaration.date.calendar
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = calendar.timeZone
            dateFormatter.locale = calendar.locale
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter
        }()
        static var formatterAPI: DateFormatter = {
            let calendar = Declaration.date.calendar
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = calendar.timeZone
            dateFormatter.locale = calendar.locale
            dateFormatter.dateFormat = "yyyy-MM-dd%20HH:mm:ss"
            return dateFormatter
        }()
    }

    // MARK: - symbol
    struct symbol {
        struct dayOfWeek {
            static let minWidth: CGFloat = 450.0
            static func sunday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันอาทิตย์" : "อา"
            }
            static func monday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันจันทร์" : "จ"
            }
            static func tuesday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันอังคาร" : "อ"
            }
            static func wednesday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันพุธ" : "พ"
            }
            static func thursday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันพฤหัสบดี" : "พฤ"
            }
            static func friday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันศุกร์" : "ศ"
            }
            static func saturday(_ screenSize: CGSize) -> String {
                return (screenSize.width > minWidth) ? "วันเสาร์" : "ส"
            }
        }
    }
    
    static let heightForRow: CGFloat = 110.0
    // MARK: - keyDict
    struct keyDict {
        static let title = "title"
        static let value = "value"
    }
    // MARK: - duration
    struct duration {
        static let updateConstraint = 0.3
    }
    // MARK: - tag
    struct tag {
        static let loading = 99100
        static let caution = 99101
        static let tagsView = 99200
        static let tagsViewButton = 99210
        static let tagsViewImage = 99220
    }
}
