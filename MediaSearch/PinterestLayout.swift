//
//  PinterestLayout.swift
//  SampleRxSwift
//
//  Created by sakiyamaK on 2019/01/08.
//
import UIKit

protocol PinterestLayoutDelegate: class {
  func cellHeight(
    collectionView: UICollectionView,
    indexPath: IndexPath,
    cellWidth: CGFloat) -> CGFloat
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {

  var cellHeight: CGFloat = 0.0

  override func copy(with zone: NSZone?) -> Any {
    // swiftlint:disable force_cast
    let copy = super.copy(with: zone) as! PinterestLayoutAttributes
    copy.cellHeight = cellHeight
    return copy
  }

  override func isEqual(_ object: Any?) -> Bool {
    guard let attributes = object as? PinterestLayoutAttributes,
      attributes.cellHeight == cellHeight else { return false }
    return super.isEqual(object)
  }
}

class PinterestLayout: UICollectionViewLayout {

  weak var delegate: PinterestLayoutDelegate?
  var cache = [(attributes: PinterestLayoutAttributes, height: CGFloat)]()

  let NUMBER_OF_COLUMN = 3 //カラム数
  let CELL_PADDING: CGFloat = 8.0 //セルのパディング
  var contentHeight: CGFloat = 0.0
  var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return collectionView!.bounds.width - (insets.left + insets.right)
  }

  var columnWidth: CGFloat { return contentWidth / CGFloat(NUMBER_OF_COLUMN) }
  var cellWidth: CGFloat { return columnWidth - CELL_PADDING * 2 }

  override class var layoutAttributesClass: AnyClass {
    return PinterestLayoutAttributes.self
  }

  override func prepare() {
    super.prepare()
    guard
      let collectionView = self.collectionView,
      collectionView.numberOfSections > 0,
      let delegate = self.delegate
      else {
        return
    }
    self.removeCacheIfNeeded()

    var (xOffsets, yOffsets) = self.initXYOffset()

    var columnIndex = 0

    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      func loopNext(height: CGFloat) {
        yOffsets[columnIndex] = yOffsets[columnIndex] + height
        columnIndex = (columnIndex + 1) % NUMBER_OF_COLUMN
      }

      guard item >= cache.count else {
        loopNext(height: cache[item].height)
        continue
      }

      let indexPath = IndexPath(item: item, section: 0)

      let cellHeight = delegate.cellHeight(collectionView: collectionView, indexPath: indexPath, cellWidth: self.cellWidth)

      let rowHeight = 2 * CELL_PADDING + cellHeight

      let frame = CGRect(
        x: xOffsets[columnIndex],
        y: yOffsets[columnIndex],
        width: self.columnWidth,
        height: rowHeight)

      do {
        let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
        attributes.cellHeight = cellHeight
        attributes.frame = frame.insetBy(dx: self.CELL_PADDING, dy: self.CELL_PADDING)
        cache.append((attributes, rowHeight))
      }

      do {
        contentHeight = max(contentHeight, frame.maxY)
        loopNext(height: rowHeight)
      }
    }
  }

  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return cache.filter { $0.attributes.frame.intersects(rect) }.map { $0.attributes }
  }
}

private extension PinterestLayout {

  func removeCacheIfNeeded() {
    guard
      let collectionView = self.collectionView,
      collectionView.numberOfSections > 0
      else {
        cache.removeAll()
        return
    }

    let numberOfItems = collectionView.numberOfItems(inSection: 0)
    if cache.count - numberOfItems > 0 {
      for _ in 0 ..< cache.count - numberOfItems {
        cache.removeLast()
      }
    }
  }

  func initXYOffset() -> ([CGFloat], [CGFloat]) {
    var xOffsets = [CGFloat]()
    for column in 0 ..< NUMBER_OF_COLUMN {
      xOffsets.append(CGFloat(column) * columnWidth)
    }
    let yOffsets = [CGFloat](repeating: 0, count: NUMBER_OF_COLUMN)

    return (xOffsets, yOffsets)
  }
}
