//
//  QuickLookViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit
import QuickLook
import Alamofire

class QuickLookViewController: QLPreviewController {
    // MARK: - @IBOutlet
    fileprivate var loader: CTLoadingView?

    var meetingId: Int?
    var urlString: String?
    var fileName: String?
    var previewItems: [URL] = []
    var isFirstTime: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = CTLoadingView.instanceFromNib(view)
        view.backgroundColor = Appearance.pdfBackgroundColor
        dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstTime == true {
            performLoad()
            isFirstTime = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        API.downloadRequest?.cancel()
    }
    
    func loading(enable: Bool) {
        if enable == true {
            loader?.show()
        }
        else {
            loader?.hide()
        }
        view.subviews.forEach { (subview) in
            subview.subviews.forEach({ (view) in
                if let label = view as? UILabel {
                    label.isHidden = enable
                }
            })
        }
    }
    
    func updateView() {
        loading(enable: false)
        reloadData()
        view.subviews.forEach { (subview) in
            subview.subviews.forEach({ (view) in
                view.subviews.forEach({ (vi) in
                    if let scrollView = vi as? UIScrollView { // for image
                        scrollView.backgroundColor = Appearance.pdfBackgroundColor
                    }
                })
            })
        }
    }
    func performLoad() {
        let fileName = self.fileName ?? "Sample.pdf"
        loading(enable: true)
        if let url = PDF.shared.fetchFileURL(fileName) {
            previewItems = [url]
            updateView()
        }
        else {
            let urlString = self.urlString ?? ""
            API.download(urlString: urlString, fileName: fileName, meetingId: meetingId, onSuccess: { [weak self] (url) in
                self?.previewItems = [url]
                self?.updateView()
            }, onFailure: { [weak self] (error) in
                self?.updateView()
            })
        }
    }
}

//MARK:- QLPreviewController Datasource
extension QuickLookViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItems.count
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let item = previewItems[index] as QLPreviewItem
        return item
    }
}
