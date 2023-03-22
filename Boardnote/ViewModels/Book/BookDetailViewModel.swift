//
//  BookDetailViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 10/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta

class BookDetailViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    override var viewForFooter: UIView? { return nil }
    var meetingId: Int?
    var meetingType: String?
    var dataSourceMenu: [MMeetingTopic] = []
    var meeting: MMeeting? { return resource as? MMeeting }
    
    override init() {
        super.init()
    }
    init(meetingId: Int?, meetingType: String?) {
        super.init()
        self.meetingId = meetingId
        self.meetingType = meetingType
        currentPage = 0
        endOfData = true
    }
    
    // MARK: - Reload
    func reloadMenu() {
        dataSourceMenu = meeting?.topics ?? []
        if dataSourceMenu.count > 0 {
            let item = MMeetingTopic(JSON: [:])!
            item.title = LocalizedText.overall_title
            dataSourceMenu.insert(item, at: 0)
        }
    }
    func reloadData() {
        var result: [MMeetingTopic] = []
        if meetingType == MCategoryType.meeting.rawValue || meetingType == MCategoryType.meetingArchive.rawValue {
            if dataSourceMenu.count > currentPage {
                if currentPage == 0 {
                    for (index, value) in dataSourceMenu.enumerated() {
                        if index == 0 { continue }
                        let topic = value.subtopics ?? []
                        result.append(value)
                        result.append(contentsOf: topic)
                    }
                }
                else {
                    let source = dataSourceMenu[currentPage]
                    result.append(contentsOf: source.subtopics ?? [])
                    result.insert(source, at: 0)
                }
            }
        }
        else if meetingType == MCategoryType.news.rawValue, let news = meeting?.news {
            result.append(news)
        }
        else if meetingType == MCategoryType.documentPage.rawValue {
            for (index, value) in dataSourceMenu.enumerated() {
                if index == 0 { continue }
                result.append(value)
            }
        }
        dataSource = result
    }
    
    // MARK: - Local
    override func onLocalLoad() {
        super.onLocalLoad()
        var key = ""
        let id = meetingId ?? 0
        if meetingType == MCategoryType.meeting.rawValue {
            key = CacheKey.meetings(meetingId: id)
        }
        else if meetingType == MCategoryType.news.rawValue {
            key = CacheKey.news(meetingId: id)
        }
        else if meetingType == MCategoryType.documentPage.rawValue {
            key = CacheKey.document(meetingId: id)
        }
        Cache.fetch(key: key,
                    onMapping: CacheMapping.meetingDetail,
                    onSuccess: onLocalSuccess,
                    onCompletion: onLocalCompletion)
        onServerCounter()
    }
    override var onLocalSuccess: ((Any?) -> Void)? {
        return { [weak self] (result) in
            guard let meeting = result as? MMeeting else {
                self?.onServerLoad() // server load
                return
            }
            self?.resource = meeting
            self?.reloadMenu()
            self?.reloadData()
            if (self?.dataSource.count ?? 0) > 0 {
                self?.ui?.hideLoader()
                self?.apiStatus = CTAPIStatus.success
            }
            // server load
            self?.onServerLoad()
        }
    }
    
    // MARK: - Server
    override func onServerLoad() {
        super.onServerLoad()
        if meetingType == MCategoryType.meeting.rawValue {
            API.getMeeting(meetingId: meetingId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
        else if meetingType == MCategoryType.news.rawValue {
            API.getNews(meetingId: meetingId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
        else if meetingType == MCategoryType.documentPage.rawValue {
            API.getDocument(meetingId: meetingId, onSuccess: onServerSuccess, onFailure: onServerFailure, onCompletion: onServerCompletion)
        }
    }
    override var onServerSuccess: (CTAPI.onSuccess)? {
        return { [weak self] (result, status) in
            // status
            self?.apiStatus = status
            if self?.apiStatus == .dataNotFound {
                self?.ui?.cautionUnit = .dataNotFound
            }
            // data
            if let meeting = result as? MMeeting {
                self?.resource = meeting
                self?.reloadMenu()
                self?.reloadData()
            }
        }
    }
    
    override func onServerCancel() {
        if meetingType == MCategoryType.meeting.rawValue {
            API.cancelMeeting()
        }
        else if meetingType == MCategoryType.news.rawValue {
            API.cancelNews()
        }
        else if meetingType == MCategoryType.documentPage.rawValue {
            API.cancelDocument()
        }
    }
    
    func onServerCounter() {
        if let id = meetingId {
            API.counterMeeting(id)
        }
    }
}
