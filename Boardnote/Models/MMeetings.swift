//
//  MMeetings.swift
//  Boardnote
//
//  Created by Julapong on 3/6/18.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class MMeetings: CTModel {    
    var status: String?
    var data: [MMeeting]?
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        status  <- map["status"]
        data    <- map["data"]
    }
}

class MMeeting: CTModel {
    var id: Int?
    var date: String?
    var date_gmt: String?
    var guid: String?
    var modified: String?
    var modified_gmt: String?
    var slug: String?
    var status: String?
    var type: String?
    var link: String?
    var title: String?
    var template: String?
    var categories: [Int]?
    var locations: [Int]?
    var topics: [MMeetingTopic]?
    var time: String?
    var category: [MCategory]?
    var chairman: MUser?
    var location: MMeetingLocation?
    var locationDetails: String?
    var beacons: [MBeacon]?
    var allowCheckin: Bool?
    var news: MMeetingTopic?
    
    func splitTime(_ time: String, dateIndex: Int) -> String {
        let array = time.split(separator: " ")
        if array.count > 1 {
            let date = array[0]
            let array = date.split(separator: "/")
            if array.count > 2 {
                return String(array[dateIndex])
            }
        }
        return ""
    }
    var dateDisplay: String {
        guard let time = self.time else { return "" }
        return self.splitTime(time, dateIndex: 0)
    }
    var monthDisplay: String {
        guard let time = self.time else { return "" }
        let month = Int(self.splitTime(time, dateIndex: 1)) ?? 1
        let arrayMonth = ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
        return arrayMonth[(month - 1)]
    }
    var yearDisplay: String {
        guard let time = self.time else { return "" }
        return self.splitTime(time, dateIndex: 2)
    }
    var timeDisplay: String {
        guard let time = self.time else { return "" }
        let array = time.split(separator: " ")
        if array.count > 1 {
            let time = array[1]
            let array = time.split(separator: ":")
            if array.count > 2 {
                return "\(String(array[0])):\(String(array[1])) น."
            }
            return String(array[1])
        }
        return ""
    }
    var dateCaledar: String? {
        guard let time = self.time else { return nil }
        let date = time.split(separator: " ")
        let result: String? = (date.count > 0) ? String(date[0]) : nil
        return result
    }
    
    var locationDisplay: String {
        guard let location = self.location, let name = location.name else { return "" }
        let detail = self.locationDetails ?? ""
        return "\(name) \(detail)"
    }
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        id                  <- map["id"]
        date                <- map["date"]
        date_gmt            <- map["date_gmt"]
        guid                <- map["guid.rendered"]
        modified            <- map["modified"]
        modified_gmt        <- map["modified_gmt"]
        slug                <- map["slug"]
        status              <- map["status"]
        type                <- map["type"]
        link                <- map["link"]
        title               <- map["title.rendered"]
        template            <- map["template"]
        categories          <- map["categories"]
        locations           <- map["locations"]
        topics              <- map["acf.topics"]
        time                <- map["acf.meeting_time"]
        category            <- map["acf.category"]
        chairman            <- map["acf.chairman"]
        location            <- map["acf.location"]
        locationDetails     <- map["acf.location_details"]
        beacons             <- map["acf.beacons"]
        allowCheckin        <- map["acf.allow_checkin"]
        news                <- map["acf"]
    }
    
    // MARK: - Utility
}

class MMeetingTopic: CTModel {
    var number: String?
    var title: String?
    var attachments: [MMeetingAttachment]?
    var isCategory: Bool?
    var subtopics: [MMeetingTopic]?
    
    var numberAndTitle: String {
        guard let title = self.title else { return "" }
        if self.isCategory == true {
            return title
        }
        if let number = self.number {
            return "\(LocalizedText.number_title) \(number) \(title)"
        }
        return title
    }
    var isSubCategory: Bool {
        return (self.isCategory == true || self.isCategory == false)
    }
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        number      <- map["topic_number"]
        number      <- map["subtopic_number"]
        title       <- map["title"]
        attachments <- map["attachments"]
        isCategory  <- map["is_category"]
        subtopics   <- map["subtopics"]
    }
}

class MMeetingAttachment: CTModel {
    public enum FileFormat {
        case image, microsoft, pdf
    }
    var id: Int?
    var title: String?
    var filename: String?
    var filesize: Int?
    var url: String?
    var link: String?
    var alt: String?
    var author: String?
    var description: String?
    var caption: String?
    var name: String?
    var status: String?
    var uploaded_to: Int?
    var date: String?
    var modified: String?
    var menu_order: Int?
    var mime_type: String?
    var type: String?
    var subtype: String?
    var icon: String?
    
    var urlString: String? {
        guard let url = self.url, let filename = self.filename?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        var items = url.split(separator: "/")
        if items.count > 1 {
            items.remove(at: items.count-1)
        }
        var result: String = ""
        for (index, value) in items.enumerated() {
            if index == 0 {
                result = "\(value)/"
            }
            else {
                result = "\(result)/\(value)"
            }
        }
        return "\(result)/\(filename)"
    }
    var iconImage: UIImage? {
        guard let fileformat = self.fileformat else { return nil }
        var result:UIImage?
        switch fileformat {
            case .image:        result = #imageLiteral(resourceName: "ic_format_image")
            case .microsoft:    result = #imageLiteral(resourceName: "ic_format_microsoft")
            case .pdf:          result = #imageLiteral(resourceName: "ic_format_pdf")
        }
        return result
    }
    var extensions: String? {
        guard let filename = self.filename else { return nil }
        let file = filename.components(separatedBy: ".")
        if file.count < 1 { return nil }
        guard let result = file.last else { return nil }
        return result
    }
    var fileformat: FileFormat? {
        guard let extensions = self.extensions else { return nil }
        var result: FileFormat?
        if extensions == "bmp" || extensions == "wmf" || extensions == "emf" || extensions == "gif" || extensions == "hdp" || extensions == "jpg" || extensions == "jp2" || extensions == "jpc" || extensions == "png" || extensions == "tif" || extensions == "tiff" {
            result = .image
        }
        else if extensions == "doc" || extensions == "docx" || extensions == "xlsx" || extensions == "pptx" || extensions == "pub" {
            result = .microsoft
        }
        else if extensions == "pdf" || extensions == "fdf" || extensions == "xfdf" {
            result = .pdf
        }
        return result
    }
    
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        id              <- map["file.id"]
        title           <- map["file.title"]
        filename        <- map["file.filename"]
        filesize        <- map["file.filesize"]
        url             <- map["file.url"]
        link            <- map["file.link"]
        alt             <- map["file.alt"]
        author          <- map["file.author"]
        description     <- map["file.description"]
        caption         <- map["file.caption"]
        name            <- map["file.name"]
        status          <- map["file.status"]
        uploaded_to     <- map["file.uploaded_to"]
        date            <- map["file.date"]
        modified        <- map["file.modified"]
        menu_order      <- map["file.menu_order"]
        mime_type       <- map["file.mime_type"]
        type            <- map["file.type"]
        subtype         <- map["file.subtype"]
        icon            <- map["file.icon"]
    }
}

class MMeetingLocation: CTModel {
    var id: Int?
    var name: String?
    var slug: String?
    var term_group: Int?
    var term_taxonomy_id: Int?
    var taxonomy: String?
    var description: String?
    var parent: Int?
    var count: Int?
    var filter: String?
    
    // MARK: - Mapping
    override func mapping(map: Map) {
        id                  <- map["term_id"]
        name                <- map["name"]
        slug                <- map["slug"]
        term_group          <- map["term_group"]
        term_taxonomy_id    <- map["term_taxonomy_id"]
        taxonomy            <- map["taxonomy"]
        description         <- map["description"]
        parent              <- map["parent"]
        count               <- map["count"]
        filter              <- map["filter"]
    }
}
