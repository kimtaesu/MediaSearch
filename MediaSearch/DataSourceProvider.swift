//
//  DataSourceProvier.swift
//  MediaSearch
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

struct DataSourceProvider {
  private init() { }

  static let shared = DataSourceProvider()

  public typealias ThumbnailDecideViewTransition
    = (CollectionViewSectionedDataSource<ThumbnailSection>, UICollectionView, [Changeset<ThumbnailSection>]) -> ViewTransition
  public typealias ThumbnailConfigureCell
    = (CollectionViewSectionedDataSource<ThumbnailSection>, UICollectionView, IndexPath, ThumbnailView) -> UICollectionViewCell
  public typealias LoadMoreConfigureSupplementaryView
    = (CollectionViewSectionedDataSource<ThumbnailSection>, UICollectionView, String, IndexPath) -> UICollectionReusableView

  let thumbnaulConfiureCell: ThumbnailConfigureCell = { ds, cv, ip, item in
    switch item {
    case .thumbnail(let thumbnail):
      guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.swiftIdentifier, for: ip) as? ThumbnailCell
        else { return UICollectionViewCell() }
      
      cell.thumbnail.beautiful.setImage(with: URL(string: thumbnail.thumbnail_url))
      return cell
    case .loadMore:
      guard let cell = cv.dequeueReusableCell(withReuseIdentifier: LoadMoreView.swiftIdentifier, for: ip) as? ThumbnailCell
        else { return UICollectionViewCell() }
      return cell
    }
  }
  let loadMoreConfigureSupplementaryView: LoadMoreConfigureSupplementaryView = { ds, cv, kind, ip in
    if kind == UICollectionView.elementKindSectionFooter {
      guard let footer = cv.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: LoadMoreView.swiftIdentifier,
        for: ip
      ) as? LoadMoreView else { return UICollectionReusableView() }
      return footer
    } else {
      return UICollectionReusableView()
    }
  }
  let noneAnimationConfiguration = AnimationConfiguration(insertAnimation: .none, reloadAnimation: .none, deleteAnimation: .none)
  let bottomAnimationConfiguration = AnimationConfiguration(insertAnimation: .bottom, reloadAnimation: .bottom, deleteAnimation: .bottom)
}
