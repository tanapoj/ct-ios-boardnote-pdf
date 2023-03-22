//
//  PDFHelper.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 28/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import PDFNet

class PDFSettings {
    enum ViewMode: Int {
        case singlePage, continuous, facing, coverFacing
    }
    enum NightMode: Int {
        case normal, night
    }
    
    var viewMode: ViewMode = .singlePage
    var nightMode: NightMode = .normal
    init() {}
    
    static func mapping(_ source: [String:Any]?) -> PDFSettings {
        let source = source ?? [:]
        let result = PDFSettings()
        result.viewMode = ViewMode(rawValue: (source["view_mode"] as? Int) ?? 0) ?? .singlePage
        result.nightMode = NightMode(rawValue: (source["night_mode"] as? Int) ?? 0) ?? .normal
        return result
    }
    func source() -> [String:Any] {
        var result:[String:Any] = [:]
        result["view_mode"] = self.viewMode.rawValue
        result["night_mode"] = self.nightMode.rawValue
        return result
    }
}

class PDF {
    var directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var settings: PDFSettings!
    
    // MARK: - Shared Instance
    static let shared = PDF()
    // MARK: - Initialization Method
    private init() {}
    
    func setup() {
        PTPDFNet.initialize("Centrillion Technology Co., Ltd.(centrilliontech.io):ENTERP:MD iNote::I:AMS(20190912):857755501FD72AD003337A782F617FFB04C1850B954C0D73446C40D04AF2B6F5C7")
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL = documentsURL.appendingPathComponent("Boardnote")
        directoryURL = documentsURL
    }
    
    func fetchFileURLs() -> [URL] {
        var result: [URL] = []
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            result = fileURLs
            CLog(fileURLs)
        } catch {
            CLog("Error while enumerating files \(directoryURL.path): \(error.localizedDescription)")
        }
        return result
    }
    
    func fetchFileURL(_ fileName: String) -> URL? {
        let url = directoryURL.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            //CLog(url.pathExtension)
            if url.pathExtension == "pdf" {
                CLog("fileExists-url: \(url.path)")
                return url
            }
            else {
                let pdfURL = url.deletingPathExtension().appendingPathExtension("pdf")
                if FileManager.default.fileExists(atPath: pdfURL.path) {
                    CLog("fileExists-pdfURL: \(pdfURL.path)")
                    return pdfURL
                }
                CLog("fileExists-url: \(url.path)")
                return url
            }
        }
        return nil
    }
    
    func clearAll() {
        do {
            CLog("ClearAll: \(directoryURL.path)")
            try FileManager.default.removeItem(atPath: directoryURL.path)
        }
        catch let error as NSError {
            CLog("Ooops! Something went wrong: \(error)")
        }
    }
}
