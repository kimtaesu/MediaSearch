//
//  UICollectionViewGridThumbnail.swift
//  MediaSearch
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

protocol UICollectionViewGridThumbnail where Self: UIViewController {
}

extension UICollectionViewGridThumbnail {
  var column: Int {
    return 3
  }
}

extension UICollectionViewGridThumbnail {
  func gridCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
    let sectionInset = collectionViewLayout.sectionInset
    let contentWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
      - sectionInset.left
      - sectionInset.right
      - collectionView.contentInset.left
      - collectionView.contentInset.right
      - collectionViewLayout.minimumInteritemSpacing * CGFloat((column - 1))
    
    let referenceWidth = contentWidth / CGFloat(column)
    
    return CGSize(width: referenceWidth, height: referenceWidth)
  }
}
