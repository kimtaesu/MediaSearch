//
//  SnappingCollectionViewLayout.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
  override func prepare() {

  }
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

    var offsetAdjustment = CGFloat.greatestFiniteMagnitude
    let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

    let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

    let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

    layoutAttributesArray?.forEach({ layoutAttributes in
      let itemOffset = layoutAttributes.frame.origin.x
      if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
        offsetAdjustment = itemOffset - horizontalOffset
      }
    })
    return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
  }
}
