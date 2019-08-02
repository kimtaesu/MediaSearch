//
//  StoreViewController.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit

class MyStoreViewController: BaseViewController, UserProgressView {

  @IBOutlet weak var collectionView: UICollectionView!
  
  let viewModel: MyStoreViewModel
  var items: [Thumbnailable] = []
  let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = L10n.favoriteEmpty
    label.apply(ViewStyle.empty)
    return label
  }()
  
  let dataSource = RxCollectionViewSectionedAnimatedDataSource<ImageSection>(
    animationConfiguration: DataSourceProvider.shared.noneAnimationConfiguration, configureCell: { ds, cv, ip, item -> UICollectionViewCell in
      guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.swiftIdentifier, for: ip) as? ThumbnailCell else {
        return UICollectionViewCell()
      }
      cell.thumbnail.beautiful.setImage(with: URL(string: item.origin_url))
      return cell
      }
  )

  init(viewModel: MyStoreViewModel) {
    self.viewModel = viewModel
  }

  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = L10n.myStoreTitle
    collectionView.do {
      $0.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
      $0.rx.setDelegate(self).disposed(by: disposeBag)
      $0.register(ThumbnailCell.nib, forCellWithReuseIdentifier: ThumbnailCell.swiftIdentifier)
    }
    
    self.rx.viewDidAppear
      .bind(to: viewModel.fetchFavorites)
      .disposed(by: disposeBag)

    viewModel.loading
      .distinctUntilChanged()
      .debug("loading")
      .bind(to: self.rx.showProgress)
      .disposed(by: disposeBag)
    
    viewModel.isEmpty
      .distinctUntilChanged()
      .bind { [weak self] empty in
        guard let self = self else { return }
        if empty {
          self.collectionView.backgroundView = self.emptyLabel
        } else {
          self.collectionView.backgroundView = nil
        }
      }
      .disposed(by: disposeBag)
    
    viewModel.sections
      .distinctUntilChanged()
      .debug("sections")
      .bind(to: collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
  }
  func reloadFavorites() {
    viewModel.fetchFavorites.accept((true))
  }
}

extension MyStoreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewGridThumbnail {
  func firstItemByIndexPath(_ ip: IndexPath) -> Thumbnailable {
    return viewModel.getItem(indexPath: ip)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.gridCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let storeViewModel = ImageViewModel(store: StoreService(scheduler: RxScheduler()), sections: viewModel.allSections(), selectedIndex: indexPath, scheduler: RxScheduler())
    let toVC = ImageViewController(viewModel: storeViewModel, rightMenuOption: [.save])
    self.present(toVC, animated: true)
  }
}
