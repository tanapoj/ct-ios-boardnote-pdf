//
//  CTCollectionViewCell.swift
//  CTLibraries
//
//  Created by Julapong Techapakornrat on 24/08/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import UIKit

public protocol CTCollectionViewCellInterface {
    static var cellId: String { get }
    static var bundle: Bundle { get }
    static var nib: UINib { get }
    
    static func register(with collectionView: UICollectionView)
    static func dequeueReusableCell(with collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

open class CTCollectionViewCell: UICollectionViewCell, CTCollectionViewCellInterface {
    open class var cellId: String { return "CTCollectionViewCell" }
    open class var bundle: Bundle { return Bundle(for: self) }
    open class var nib: UINib { return UINib(nibName: cellId, bundle: bundle) }
    
    open class func register(with collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    open class func dequeueReusableCell(with collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
}
