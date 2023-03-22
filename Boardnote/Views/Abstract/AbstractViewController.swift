//
//  AbstractViewController.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 06/07/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

class AbstractViewController: CTViewController {
    var collectionViewHeightForRow: CGFloat { return 150.0 }
    
    // MARK: - Property override
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life cycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // collectionView
        if let collectionView = self.collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.invalidateLayout()
        }
    }
    
    // MARK: - init - UITextField
    fileprivate var textFields: [UITextField]?
    func initTextField(_ textFields: [UITextField]?) {
        self.textFields = textFields
        self.textFields?.forEach({ (textField) in
            textField.delegate = self
        })
    }
}

//MARK: - Binding
extension AbstractViewController {
    
}

// MARK: - UITextFieldDelegate
extension AbstractViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFields = self.textFields else { return true }
        guard let index = textFields.index(of: textField) else { return true }
        textField.resignFirstResponder()
        if index == (textFields.count - 1) {
            self.textFieldShouldDone()
        }
        else {
            let field = textFields[index + 1]
            field.becomeFirstResponder()
        }
        return true
    }
    @objc func textFieldShouldDone() {
        ILog("**** textFieldShouldDone: not implement ****")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AbstractViewController: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let col: CGFloat = (collectionView.frame.size.width < 500) ? 1.0 : 2.0
        var width: CGFloat = (collectionView.frame.size.width / col) - (16.0 * 2)
        if col > 1.0 {
            width = width + (16.0 / 2)
        }
        return CGSize(width: width, height: collectionViewHeightForRow)
    }
}
