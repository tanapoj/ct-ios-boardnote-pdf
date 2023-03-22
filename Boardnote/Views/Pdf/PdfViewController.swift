//
//  PdfViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 28/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import CoreFoundation
import UIKit
import PDFNet
import Tools
import Alamofire

class PdfViewController: AbstractViewController {
    
    // MARK: - @IBOutlet
    private let statusBarView = UIView()
    @IBOutlet private weak var annotationToolbarView: UIView!
    @IBOutlet private weak var annotationToolbarViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var annotationToolbarViewTop: NSLayoutConstraint!
    @IBOutlet private weak var toolsView: UIView!
    @IBOutlet private weak var toolBarView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var pageModeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    
    var urlString: String?
    var fileName: String?
    var meetingId: Int?
    
    fileprivate var vmData: PdfViewModelData!
    fileprivate var activityViewController: UIActivityViewController?
    fileprivate var pdfSettingsViewController: PdfSettingsViewController!
    fileprivate var pdfViewCtrl: PTPDFViewCtrl!
    fileprivate var toolManager: ToolManager?
    fileprivate var annotationToolbar: AnnotationToolbar?
    fileprivate var isFirstTime: Bool = true
    fileprivate var isEdit: Bool = false
    fileprivate var url: URL?
    fileprivate var pdfDoc: PTPDFDoc?
    fileprivate var annotationAuthor: String = "Julapong"
    fileprivate var forceNavigationBarHidden = false
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.forceNavigationBarHidden == false {
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.statusBarView.frame = UIApplication.shared.statusBarFrame
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (contexr) in
            //self?.annotationToolbar?.rotate(to: UIApplication.shared.statusBarOrientation)
            self?.annotationToolbar?.rotate(to: UIDevice.current.orientation)
            self?.viewMode()
        }) { [weak self] (context) in
            //self?.annotationToolbar?.rotate(to: UIApplication.shared.statusBarOrientation)
            self?.annotationToolbar?.rotate(to: UIDevice.current.orientation)
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - init
    override func initView() {
        super.initView()
        self.setupView()
    }
    
    // MARK: - Action
    func open(_ url: URL) -> Bool {
        self.save()
        if url.isFileURL {
            CLog("open: \(url.path)")
            let file = url.path.components(separatedBy: ".")
            if let type = file.last, type == "pdf" {
                self.pdfDoc = PTPDFDoc.init(filepath: url.path)
            }
            else {
                self.pdfDoc = PTPDFDoc.init()
                PTConvert.toPdf(self.pdfDoc, in_filename: url.path)
            }
            self.url = url
            if let pdfDoc = self.pdfDoc {
                self.toolManager?.tool = PanTool.init(pdfViewCtrl: self.pdfViewCtrl)
                self.toolManager?.tool?.annotationAuthor = self.annotationAuthor
                self.pdfViewCtrl.setDoc(pdfDoc)
                pdfDoc.lockRead()
                self.viewMode()
                self.nightMode()
                pdfDoc.unlockRead()
                return true
            }
        }
        return false
    }
    func edit(_ isEdit: Bool) {
        self.forceNavigationBarHidden = isEdit
        self.isEdit = isEdit
        self.updateAnnotationToolbarView(isEdit)
        self.toolManager?.tool = PanTool.init(pdfViewCtrl: self.pdfViewCtrl)
    }
    func save() {
        let isRendering = !self.pdfViewCtrl.isFinishedRendering(false)
        if isRendering {
            self.pdfViewCtrl.cancelRendering()
        }
        self.pdfViewCtrl.docLock(true)
        if let url = self.url, let pdfDoc = self.pdfDoc, pdfDoc.isModified() == true {
            var path = url.path
            if url.pathExtension != "pdf" {
                let tmp = url.deletingPathExtension().appendingPathExtension("pdf")
                path = tmp.path
            }
            CLog("save: \(path)")
            pdfDoc.lock()
            pdfDoc.save(toFile: path, flags: 0)
            pdfDoc.unlock()
        }
        self.pdfViewCtrl.docUnlock()
    }
    func viewMode() {
        var mode: TrnPagePresentationMode = e_trn_single_page
        if PDF.shared.settings.viewMode == .continuous {
            mode = e_trn_single_continuous
        }
        else if PDF.shared.settings.viewMode == .singlePage {
            mode = e_trn_single_page
        }
        else if PDF.shared.settings.viewMode == .facing {
            mode = e_trn_facing
        }
        else if PDF.shared.settings.viewMode == .coverFacing {
            mode = e_trn_facing_cover
        }
        self.pdfViewCtrl.setPagePresentationMode(mode)
    }
    func nightMode() {
        if PDF.shared.settings.nightMode == .night {
            self.pdfViewCtrl.setColorPostProcessMode(e_ptpostprocess_invert)
            self.pdfViewCtrl.setProgressiveRendering(false, withInitialDelay: 0, withInterval: 750)
        }
        else {
            self.pdfViewCtrl.setColorPostProcessMode(e_ptpostprocess_none)
            self.pdfViewCtrl.setProgressiveRendering(true, withInitialDelay: 0, withInterval: 750)
        }
        self.pdfViewCtrl.update(true)
    }
    
    
    // MARK: - Setup BarButton
    @IBAction func backButtonDidTouch(_ sender: Any) {
        if let pdfDoc = self.pdfDoc, pdfDoc.isModified() == true {
            Alert.confirmPdf(self, handlerOk: {
                self.save()
                self.navigationController?.popViewController(animated: true)
            }, handlerCancel: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func editButtonDidTouch(_ sender: Any) {
        self.edit(true)
    }
    @IBAction func pageModeButtonDidTouch(_ sender: Any) {
        self.forceNavigationBarHidden = true
        self.pdfSettingsViewController.delegate = self
        Navigation.presentViewController(self.pdfSettingsViewController)
    }
    @IBAction func saveButtonDidTouch(_ sender: Any) {
        self.save()
    }
    @IBAction func shareButtonDidTouch(_ sender: UIButton) {
        guard let activityViewController = self.activityViewController else { return }
        self.present(activityViewController, animated: true)
        if let popOver = activityViewController.popoverPresentationController {
            popOver.sourceView = self.view
            popOver.sourceRect = sender.frame
            //popOver.barButtonItem
        }
    }
    @IBAction func bookmarkButtonDidTouch(_ sender: Any) {
        ILog("bookmark")
    }
    @IBAction func searchButtonDidTouch(_ sender: Any) {
        ILog("search")
    }
}

//MARK: - Binding UI
extension PdfViewController {
    // MARK: - Setup view
    func setupView() {
        self.view.backgroundColor = Appearance.greenColor
        self.setupStatusView()
        self.setupToolsView()
        self.setupContentView()
        self.setupSettingsViewController()
    }
    func setupStatusView() {
        self.statusBarView.backgroundColor = Appearance.greenColor
        self.view.addSubview(self.statusBarView)
    }
    func setupToolsView() {
        self.toolsView.backgroundColor = self.statusBarView.backgroundColor
        self.toolBarView.backgroundColor = UIColor.clear
        self.toolBarView.isHidden = true
        self.backButton.appearancePdfBack()
        self.pageModeButton.appearancePdfTools(#imageLiteral(resourceName: "ic_menu_vertical"))
        self.editButton.appearancePdfTools(#imageLiteral(resourceName: "ic_pencil"))
        self.saveButton.appearancePdfTools(#imageLiteral(resourceName: "ic_save"))
        self.shareButton.appearancePdfTools(#imageLiteral(resourceName: "ic_share"))
        //self.bookmarkButton.appearancePdfTools(#imageLiteral(resourceName: "ic_bookmark"))
        self.searchButton.appearancePdfTools(#imageLiteral(resourceName: "ic_search"))
        //self.bookmarkButton.isHidden = true
        self.searchButton.isHidden = true
    }
    func setupContentView() {
        self.contentView.backgroundColor = Appearance.pdfBackgroundColor
        self.setupContentPdfView()
        self.setupContentPdfAnnotationToolbarView()
    }
    func setupContentPdfView() {
        // create a PTPDFViewCtrl and add it to the view
        self.pdfViewCtrl = PTPDFViewCtrl()
        self.pdfViewCtrl.translatesAutoresizingMaskIntoConstraints = false
        self.pdfViewCtrl.setZoomLimits(e_trn_zoom_limit_relative, minimum: 1.0, maxiumum: 50.0)
        self.pdfViewCtrl.setBackgroundColor(0, g: 0, b: 0, a: 0)
        self.contentView.addSubview(self.pdfViewCtrl)
        // set constraint
        self.pdfViewCtrl.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        self.pdfViewCtrl.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        self.pdfViewCtrl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.pdfViewCtrl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        // add the toolmanager (used to implement text selection, annotation editing, etc.)
        self.toolManager = ToolManager(pdfViewCtrl: self.pdfViewCtrl)
        self.toolManager?.delegate = self
        self.pdfViewCtrl.toolDelegate = self.toolManager
    }
    func setupContentPdfAnnotationToolbarView() {
        self.annotationToolbarView.backgroundColor = self.statusBarView.backgroundColor
        self.annotationToolbarViewTop.constant = -self.annotationToolbarViewHeight.constant
        self.annotationToolbar = AnnotationToolbar.init(toolManager: self.toolManager!)
        self.annotationToolbar?.translatesAutoresizingMaskIntoConstraints = false
        self.annotationToolbar?.delegate = self;
        self.annotationToolbarView.addSubview(self.annotationToolbar!)
        // set constraint
        self.annotationToolbar?.leftAnchor.constraint(equalTo: self.annotationToolbarView.leftAnchor, constant: 0).isActive = true
        self.annotationToolbar?.rightAnchor.constraint(equalTo: self.annotationToolbarView.rightAnchor, constant: 0).isActive = true
        self.annotationToolbar?.topAnchor.constraint(equalTo: self.annotationToolbarView.topAnchor, constant: 0).isActive = true
        self.annotationToolbar?.bottomAnchor.constraint(equalTo: self.annotationToolbarView.bottomAnchor, constant: 0).isActive = true
    }
    func setupSettingsViewController() {
        self.pdfSettingsViewController = Navigation.pdfSettingsViewController()
    }
    
    // MARK: - Update view
    override func updateView() {
        viewModel.ui.hideLoader()
        toolBarView.isHidden = false
    }
    override func updateViewFailure() {
        toolBarView.isHidden = true
        viewModel.ui.hideLoader()
        viewModel.ui.showCaution(unit: .retry)
    }
    func updateAnnotationToolbarView(_ isShow: Bool) {
        let constant: CGFloat = (isShow) ? 0 : -annotationToolbarViewHeight.constant
        annotationToolbarViewTop.constant = constant
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

//MARK: - Binding Data
extension PdfViewController {
    @objc override func viewModelBindingData() {
        vmData = PdfViewModelData()
        vmData.fileName = fileName
        vmData.urlString = urlString
        vmData.meetingId = meetingId
        viewModel.data = vmData
        super.viewModelBindingData()
    }
    @objc override func onLocalCompletion() -> (() -> Void) {
        return { [weak self] in
            guard let url = self?.vmData.url else {
                self?.updateViewFailure()
                return
            }
            let opened = self?.open(url)
            if opened == true {
                self?.updateView()
                self?.activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
            }
        }
    }
    @objc override func onLocalFailure() -> (() -> Void) {
        return { [weak self] in
            self?.updateViewFailure()
        }
    }
}

// MARK: - AnnotationToolbarDelegate
extension PdfViewController: AnnotationToolbarDelegate {
    func annotationToolbarDidCancel(_ annotationToolbar: AnnotationToolbar) {
        self.edit(false)
    }
    func toolShouldGoBack(toPan annotationToolbar: AnnotationToolbar) -> Bool {
        return false
    }
}
// MARK: - PTPDFViewCtrlDelegate
extension PdfViewController: PTPDFViewCtrlDelegate {
    
}
// MARK: - ToolManagerDelegate
extension PdfViewController: ToolManagerDelegate {
    func toolManagerToolChanged(_ toolManager: ToolManager) {
        self.annotationToolbar?.setButtonFor((toolManager.tool as? Tool)!)
        if self.isEdit == false {
            (toolManager.tool as! Tool).backToPanToolAfterUse = true
//            self.save() // move to save button
        }
        toolManager.tool?.annotationAuthor = self.annotationAuthor
    }
}
// MARK: - PdfSettingsViewControllerDelegate
extension PdfViewController: PdfSettingsViewControllerDelegate {
    func pdfSettingsViewControllerDidUpdateViewMode(_ sender: PdfSettingsViewController) {
        self.viewMode()
    }
    func pdfSettingsViewControllerDidToggleNightMode(_ sender: PdfSettingsViewController) {
        self.nightMode()
    }
    func pdfSettingsViewControllerDidCompleted() {
        self.forceNavigationBarHidden = false
        self.pdfSettingsViewController.delegate = nil
    }
}
