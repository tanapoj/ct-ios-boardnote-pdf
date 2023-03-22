//
//  PdfViewModel.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 11/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation
import Siesta
import Alamofire

class PdfViewModelData: CTViewModelData {
    override var enableServerLoad: Bool { return true }
    var meetingId: Int?
    var url: URL!
    var urlString: String?
    var fileName: String?
    
    override init() {
        super.init()
    }
    
    // MARK: - Local
    override var onLocalSuccess: ((Any?) -> Void)? {
        return { [weak self] (result) in
            self?.ui?.hideLoader()
            guard let url = result as? URL else { return }
            self?.url = url
        }
    }
    override func onLocalLoad() {
        super.onLocalLoad()
        let fileName = self.fileName ?? "Sample.pdf"
        if let url = PDF.shared.fetchFileURL(fileName) {
            onLocalSuccess?(url)
            onLocalCompletion?()
        }
        else {
            let urlString = self.urlString ?? ""
            API.download(urlString: urlString, fileName: fileName, meetingId: meetingId, onSuccess: { [weak self] (url) in
                self?.onLocalSuccess?(url)
                self?.onLocalCompletion?()
            }, onFailure: { [weak self] (error) in
                self?.onLocalFailure?()
            })
        }
    }
    
    override func onServerLoad() {
        
    }
    
    override func onServerCancel() {
        API.downloadRequest?.cancel()
    }
}
