//
//  LineBreakUICollectionFlowLayout.swift
//  MediaSearch
//
//  Created by tskim on 28/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class RowBreakUICollectionFlowLayout: UICollectionViewFlowLayout {
  enum Element: String {
    case loadMore
    case cell

    var id: String {
      return self.rawValue
    }

    var kind: String {
      return "Kind\(self.rawValue.capitalized)"
    }
  }

  private var contentY: CGFloat = 0

  private var cache = [Element: [IndexPath: UICollectionViewLayoutAttributes]]()
  private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

  override func prepare() {
    guard let collectionView = collectionView,
      collectionView.numberOfSections > 0,
      let flowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout
      else {
        return
        
    }
    
    prepareCache()
    contentY = 0
    var contentX: CGFloat = 0

    for section in 0 ..< collectionView.numberOfSections {
      let numberOfItems = collectionView.numberOfItems(inSection: section)
      for item in 0 ..< numberOfItems {
        let cellIndexPath = IndexPath(item: item, section: section)
        let itemSize = flowLayout.collectionView?(collectionView, layout: self, sizeForItemAt: cellIndexPath) ?? .zero
        let attributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
        attributes.frame = CGRect(
          x: contentX,
          y: contentY,
          width: itemSize.width,
          height: itemSize.height
        )
        cache[.cell]?[cellIndexPath] = attributes

        let nextCellIndexPath = IndexPath(item: min(numberOfItems - 1, item + 1), section: section)
        let nextItemSize = flowLayout.collectionView?(collectionView, layout: self, sizeForItemAt: nextCellIndexPath) ?? .zero
        let stripContentWidth = collectionView.contentSize.width - sectionInset.left - sectionInset.right
        if stripContentWidth < contentX + nextItemSize.width + self.minimumInteritemSpacing {
          contentY += itemSize.height + self.minimumLineSpacing
          contentX = 0
        } else {
          contentX = attributes.frame.maxX + minimumInteritemSpacing
        }
      }
    }
  }
  override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[.cell]?[indexPath]
  }

  override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    visibleLayoutAttributes.removeAll(keepingCapacity: true)

    for (_, elementInfos) in cache {
      for (_, attributes) in elementInfos {
        if attributes.frame.intersects(rect) {
          visibleLayoutAttributes.append(attributes)
        }
      }
    }
    return visibleLayoutAttributes
  }
}
extension RowBreakUICollectionFlowLayout {
  private func prepareCache() {
    cache.removeAll(keepingCapacity: true)
    cache[.cell] = [IndexPath: UICollectionViewLayoutAttributes]()
  }
}
