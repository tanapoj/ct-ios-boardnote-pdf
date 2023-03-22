//
//  CTNavigationExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit
import QuickLook

// MARK: - Storyobard
struct Storyobard {
    // MARK: - Main
    struct main {
        static let name = "Main"
        struct identifier {
            static let tabBar = "AbstractTabBarController"
            static let category = "CategoryViewController"
            static let archives = "ArchivesViewController"
            static let calendar = "CalendarViewController"
            static let book = "BookViewController"
            static let bookDetail = "BookDetailViewController"
            static let checkin = "CheckinViewController"
            static let audience = "AudienceViewController"
            static let image = "ImageViewController"
            static let search = "SearchViewController"
            static let aboutUs = "AboutUsViewController"
        }
    }
    // MARK: - Authorization
    struct authorization {
        static let name = "Authorization"
        struct identifier {
            static let login = "LoginViewController"
            static let profile = "ProfileViewController"
        }
    }
    // MARK: - PDF
    struct pdf {
        static let name = "Pdf"
        struct identifier {
            static let index = "PdfViewController"
            static let settings = "PdfSettingsViewController"
        }
    }
}

// MARK: - Navigation
extension Navigation {
    enum SourceTabBarViewController {
        case home, document, calendar, profile
    }
    enum DestinationViewController {
        case tabBar, login
    }
    
    // MARK: - Utility
    static func navigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigation = AbstractNavigationController.init(rootViewController: rootViewController)
        navigation.viewControllers = [rootViewController]
        navigation.appearanceDefault()
        return navigation
    }
    static func sourceTabBarViewController(_ source: SourceTabBarViewController) -> UINavigationController {
        var controller = UIViewController()
        switch source {
            case .home:     controller = self.categoryViewController(title: LocalizedText.title_navigation_first)
            case .document: controller = self.archivesViewController(title: LocalizedText.title_navigation_second)
            case .calendar: controller = self.calendarViewController(title: LocalizedText.title_navigation_third)
            case .profile:  controller = self.profileViewController(title: LocalizedText.title_navigation_fourth)
        }
        let navigation = self.navigationController(controller)
        return navigation
    }
    static func changeToDestinationViewController(_ destination: DestinationViewController, duration: Double = 0.0) {
        var controller = UIViewController()
        switch destination {
        case .tabBar:   controller = self.tabBarController()
        case .login:    controller = self.loginViewController()
        }
        self.changeToViewController(controller, duration: duration)
    }
    static func presentViewController(_ controller: UIViewController) {
        let navigation = self.navigationController(controller)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            // topController should now be your topmost view controller
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(navigation, animated: true, completion: nil)
        }
    }
    static func pushToViewController(_ controller: UIViewController, sender: UIViewController) {
        sender.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Main
    static func tabBarController() -> AbstractTabBarController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.tabBar) as! AbstractTabBarController
        return controller
    }
    static func categoryViewController(title: String? = nil, categories: [MCategory]? = nil) -> CategoryViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.category) as! CategoryViewController
        controller.categories = categories ?? []
        controller.title = title
        return controller
    }
    static func archivesViewController(title: String? = nil) -> ArchivesViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.archives) as! ArchivesViewController
        controller.title = title
        return controller
    }
    static func calendarViewController(title: String? = nil) -> CalendarViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.calendar) as! CalendarViewController
        controller.title = title
        return controller
    }
    static func bookViewController(title: String? = nil, type: MCategoryType, category: MCategory? = nil, meetingArchive: MMeetingArchive? = nil) -> BookViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.book) as! BookViewController
        controller.type = type
        controller.category = category
        controller.meetingArchive = meetingArchive
        controller.title = title
        return controller
    }
    static func bookDetailViewController(meetingId: Int?, meetingType: String?) -> BookDetailViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.bookDetail) as! BookDetailViewController
        controller.meetingId = meetingId
        controller.meetingType = meetingType
        controller.title = ""
        return controller
    }
    static func checkinViewController(meeting: MMeeting?) -> CheckinViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.checkin) as! CheckinViewController
        controller.title = LocalizedText.check_in
        controller.meeting = meeting
        return controller
    }
    static func audienceViewController(meeting: MMeeting?) -> AudienceViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.audience) as! AudienceViewController
        controller.title = LocalizedText.audience
        controller.meeting = meeting
        return controller
    }
    static func imageViewController(urlString: String?) -> ImageViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.image) as! ImageViewController
        controller.urlString = urlString
        return controller
    }
    static func searchViewController() -> SearchViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.search) as! SearchViewController
        return controller
    }
    static func aboutUsViewController() -> AboutUsViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.main.name, identifier: Storyobard.main.identifier.aboutUs) as! AboutUsViewController
        controller.title = LocalizedText.about_us
        return controller
    }
    
    // MARK: - Authorization
    static func loginViewController() -> LoginViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.authorization.name, identifier: Storyobard.authorization.identifier.login) as! LoginViewController
        return controller
    }
    static func profileViewController(title: String? = nil) -> ProfileViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.authorization.name, identifier: Storyobard.authorization.identifier.profile) as! ProfileViewController
        controller.title = title
        return controller
    }
    
    // MARK: - PDF
    static func pdfViewController(_ urlString: String?, fileName: String?, meetingId: Int?) -> PdfViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.pdf.name, identifier: Storyobard.pdf.identifier.index) as! PdfViewController
        controller.urlString = urlString
        controller.fileName = fileName
        controller.meetingId = meetingId
        return controller
    }
    static func pdfSettingsViewController() -> PdfSettingsViewController {
        let controller = UIStoryboard.initialViewControllerWithStoryboardName(Storyobard.pdf.name, identifier: Storyobard.pdf.identifier.settings) as! PdfSettingsViewController
        return controller
    }
    
    // MARK: - QL
    static func quickLookViewController(_ urlString: String?, fileName: String?, meetingId: Int?) -> QuickLookViewController {
        let controller = QuickLookViewController()
        controller.urlString = urlString
        controller.fileName = fileName
        controller.meetingId = meetingId
        return controller
    }
}
