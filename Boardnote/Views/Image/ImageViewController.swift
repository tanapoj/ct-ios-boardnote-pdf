//
//  ImageViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/09/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - property
    fileprivate var activityViewController: UIActivityViewController?
    fileprivate var rightBarButtonItem: UIBarButtonItem?
    fileprivate var rightBarButtonItems: [UIBarButtonItem]? {
        let button = UIButton.buttonBarPdfTool(#imageLiteral(resourceName: "ic_share"), target: self, action: #selector(self.rightBarButtonDidTouch(_:)))
        let barButton = UIBarButtonItem(customView: button)
        rightBarButtonItem = barButton
        return [barButton]
    }
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = urlString {
            activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        }
        
        activityIndicatorView.tintColor = Appearance.primaryColor
        activityIndicatorView.color = Appearance.primaryColor
        activityIndicatorView.startAnimating()
        
        scrollView.backgroundColor = Appearance.pdfBackgroundColor
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.zoomScale = 1.0
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.setImage(urlString: urlString, placeholder: nil, completionHandler: { [weak self] in
            self?.activityIndicatorView.isHidden = true
        })
        scrollView.addSubview(imageView!)
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    @objc func rightBarButtonDidTouch(_ sender: UIButton) {
        guard let activityViewController = self.activityViewController else { return }
        present(activityViewController, animated: true)
        if let popOver = activityViewController.popoverPresentationController {
            popOver.sourceView = view
            popOver.barButtonItem = rightBarButtonItem
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
