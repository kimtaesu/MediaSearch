//
//  SearchController.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class MediaSearchViewController: BaseViewController, UserProgressView, UICollectionViewGridThumbnail, PinterestLayoutDelegate {

  @IBOutlet weak var thumbnailsCollectionView: UICollectionView!

  private var movingStore: (() -> Void)?
  let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = L10n.searchResultFirstEmpty
    label.apply(ViewStyle.empty)
    return label
  }()

  let refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()

  let uiSearchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.returnKeyType = .done
    searchBar.enablesReturnKeyAutomatically = false
    searchBar.placeholder = L10n.searchPlaceholder
    return searchBar
  }()
  let viewModel: MediaSearchViewModel
  let scheduler: RxSchedulerType

  let dataSource = RxCollectionViewSectionedAnimatedDataSource<ThumbnailSection>(
    animationConfiguration: DataSourceProvider.shared.noneAnimationConfiguration,
    decideViewTransition: { ds, cv, changeset in
      var itemCount = 0
      changeset.forEach {
        $0.finalSections.forEach {
          itemCount += $0.items.count
        }
      }
      let loadStyle = SearchOption.PAGE_SIZE * 2 >= itemCount ? ViewTransition.reload : ViewTransition.animated
      logger.verbose("refreshed by \(loadStyle) \(changeset)")
      return loadStyle
    },
    configureCell: { ds, cv, ip, item in
      switch item {
      case .thumbnail(let thumbnail):
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.swiftIdentifier, for: ip) as? ThumbnailCell
          else { return UICollectionViewCell() }

        cell.thumbnail.beautiful.setImage(with: URL(string: thumbnail.thumbnail_url))
        return cell
      case .loadMore:
        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.swiftIdentifier, for: ip) as? LoadMoreCell
          else { return UICollectionViewCell() }
        cell.activitiyIndicator.startAnimating()
        return cell
      }
    }
  )

  init(
    viewModel: MediaSearchViewModel,
    scheduler: RxSchedulerType,
    movingStore: (() -> Void)? = nil
  ) {
    self.viewModel = viewModel
    self.movingStore = movingStore
    self.scheduler = scheduler
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = uiSearchBar
    navigationItem.title = L10n.mediaSeachTitle
    thumbnailsCollectionView.do {
      let flowLayout = PinterestLayout()
      flowLayout.delegate = self
      $0.collectionViewLayout = flowLayout
      $0.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
      $0.rx.setDelegate(self).disposed(by: disposeBag)
      $0.backgroundView = emptyLabel
      $0.refreshControl = refreshControl
      $0.register(
        ThumbnailCell.nib,
        forCellWithReuseIdentifier: ThumbnailCell.swiftIdentifier
      )
      $0.register(
        LoadMoreCell.nib,
        forCellWithReuseIdentifier: LoadMoreCell.swiftIdentifier
      )
    }

    uiSearchBar.rx.text.orEmpty
      .debounce(0.5, scheduler: self.scheduler.main)
      .distinctUntilChanged()
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)

    // hide keypad
    uiSearchBar.rx.searchButtonClicked
      .bind { [weak self] in
        self?.hideKeypad()
      }
      .disposed(by: disposeBag)

    viewModel.isRefreshing
      .distinctUntilChanged()
      .bind(to: self.rx.showProgress)
      .disposed(by: disposeBag)

    viewModel.hiddenRefreshConrol
      .filter { !$0 }
      .debug("hiddenRefreshConrol")
      .bind(to: refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)

    refreshControl.rx.controlEvent(.valueChanged)
      .debug("beginRefreshing")
      .bind(to: viewModel.beginRefreshing)
      .disposed(by: disposeBag)

    viewModel.alertView
      .filterNil()
      .bind(to: self.rx.showAlertView)
      .disposed(by: disposeBag)

    thumbnailsCollectionView.rx.reachedBottom
      .withLatestFrom(viewModel.isRefreshing)
      .filter { !$0 }
      .withLatestFrom(viewModel.isEndPage)
      .filter { !$0 }
      .debounce(0.2, scheduler: MainScheduler.asyncInstance)
      .bind(to: viewModel.nextPage)
      .disposed(by: disposeBag)

    viewModel.isEmpty
      .distinctUntilChanged()
      .bind { [weak thumbnailsCollectionView] empty in
        if empty {
          self.emptyLabel.text = L10n.searchResultEmpty
          thumbnailsCollectionView?.backgroundView = self.emptyLabel
        } else {
          thumbnailsCollectionView?.backgroundView = nil
        }
      }
      .disposed(by: disposeBag)

    viewModel.pageEndNotificationView
      .bind(to: self.rx.showNotification)
      .disposed(by: disposeBag)

    viewModel.animatedThumbnails
      .distinctUntilChanged()
      .observeOn(scheduler.main)
      .do(onNext: { [weak self] _ in self?.hideKeypad() })
      .bind(to: thumbnailsCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  private func hideKeypad() {
    self.uiSearchBar.endEditing(true)
  }
}

extension MediaSearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let item = viewModel.getItem(indexPath) else { return .zero }
    switch item {
    case .loadMore:
      return CGSize(width: collectionView.contentSize.width, height: 60)
    default:
      return self.gridCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.size.width, height: 60)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    logger.verbose("didSelectItemAt \(indexPath)")
    let sections = viewModel.sections().map { $0.toImageSection }

    let storeViewModel = ImageViewModel(store: StoreService(scheduler: RxScheduler()), sections: sections, selectedIndex: indexPath, scheduler: RxScheduler())
    let toVC = ImageViewController(viewModel: storeViewModel, rightMenuOption: [.favorite]) {
      if self.tabBarController != nil {
        self.movingStore?()
      }
    }
    self.present(toVC, animated: true)
  }
  func cellHeight(collectionView: UICollectionView, indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
    return 130
  }
}
