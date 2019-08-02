//
//  ImageViewController3.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import NotificationView
import Photos
import RxDataSources
import UIKit

struct ImageRightMenu: OptionSet {
  let rawValue: Int
  static let favorite = ImageRightMenu(rawValue: 1 << 0)
  static let save = ImageRightMenu(rawValue: 1 << 1)
  static let all: ImageRightMenu = [.favorite, .save]
  static let none: ImageRightMenu = []
}

class ImageViewController: BaseViewController, UserProgressView, SupportNaviagation {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var optionMenuContainrView: OptionMenuView!

  var movingStore: (() -> Void)?

  let rightMenuOption: ImageRightMenu
  let panGR = UIPanGestureRecognizer()
  let viewModel: ImageViewModel
  let scheduler: RxScheduler

  let animatedDataSource = RxCollectionViewSectionedReloadDataSource<ImageSection>(
    configureCell: { ds, cv, ip, item in
      guard let imageCell = cv.dequeueReusableCell(withReuseIdentifier: ScrollingImageCell.swiftIdentifier, for: ip) as? ScrollingImageCell else {
        return UICollectionViewCell()
      }

      imageCell.imageSize = CGSize(width: item.width, height: item.height)
      imageCell.imageView.beautiful.setImage(with: URL(string: item.origin_url))
      return imageCell
    }
  )

  init(
    viewModel: ImageViewModel,
    rightMenuOption: ImageRightMenu = ImageRightMenu.none,
    scheduler: RxScheduler = RxScheduler(),
    movingStore: (() -> Void)? = nil
  ) {
    self.viewModel = viewModel
    self.movingStore = movingStore
    self.rightMenuOption = rightMenuOption
    self.scheduler = scheduler
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    optionMenuContainrView.cancelTimer()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .gray
    collectionView.do {
      let flowLayout = SnappingCollectionViewLayout()
      flowLayout.scrollDirection = .horizontal
//      flowLayout.minimumInteritemSpacing = 0
      // 세로로 스크롤하는 격자의 경우이 값은 연속 행 간의 최소 간격을 나타냅니다.
      // 가로 스크롤 그리드의 경우,이 값은 연속 열 사이의 최소 간격을 나타냅니다
//      flowLayout.minimumLineSpacing = 0
      // 스냅 속도 fast
      $0.collectionViewLayout = flowLayout
      $0.register(ScrollingImageCell.self, forCellWithReuseIdentifier: ScrollingImageCell.swiftIdentifier)
      $0.backgroundColor = .clear
      $0.decelerationRate = UIScrollView.DecelerationRate.fast
      $0.rx.setDelegate(self).disposed(by: disposeBag)
    }
    preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.width)
    panGR.delegate = self
    collectionView.addGestureRecognizer(panGR)
    optionMenuContainrView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    optionMenuContainrView.setOptionMenu(rightMenuOption)

    self.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(visibleToggleOptionMenu)))
    
    viewModel.sections
      .distinctUntilChanged()
      .bind(to: collectionView.rx.items(dataSource: animatedDataSource))
      .disposed(by: disposeBag)

    viewModel.notificationView
      .bind(to: self.rx.showNotificationWithDelegate)
      .disposed(by: disposeBag)

    viewModel.favoriteSelected
      .do(onNext: { [weak optionMenuContainrView] _ in
        optionMenuContainrView?.resetTimer()
      })
      .bind(to: optionMenuContainrView.favoriteButton.rx.isSelected)
      .disposed(by: disposeBag)

    viewModel.isLoading
      .distinctUntilChanged()
      .bind(to: self.rx.showProgress)
      .disposed(by: disposeBag)

    self.rx.viewDidLayoutSubviews
      .bind(to: viewModel.viewDidLayoutSubviews)
      .disposed(by: disposeBag)

    viewModel.selectedIndexPath
      .bind { [weak self] in
        guard let self = self else { return }
        self.collectionView.scrollToItem(at: $0, at: .centeredHorizontally, animated: false)
      }
      .disposed(by: disposeBag)

    viewModel.imageDownloaded
      .observeOn(scheduler.main)
      .subscribe(onNext: { image in
        PHPhotoLibrary.shared().savePhoto(image: image, albumName: "test", completion: { result in
          DispatchQueue.main.async {
            switch result {
            case .success:
              let succesImage = Asset.icRoundCheckCircle36pt.image.withRenderingMode(.alwaysTemplate)
              NotificationModel(
                title: L10n.notificationSavedToPhotoAppTitle,
                subtitle: nil,
                body: L10n.notificationSavedToPhotoAppBody,
                image: succesImage,
                imageTintColor: ColorName.colorAccent)
                .notificationView
                .show()
            case .failure:
              break
            }
          }
        })
      })
      .disposed(by: disposeBag)

    optionMenuContainrView.favoriteButton.rx.tap
      .bind(to: viewModel.tapsFavorite)
      .disposed(by: disposeBag)

    optionMenuContainrView.saveButton.rx.tap
      .bind(to: viewModel.tapsSave)
      .disposed(by: disposeBag)
  }

  @objc
  func close() {
    self.dismissViewController()
  }
  @objc
  func visibleToggleOptionMenu() {
    self.optionMenuContainrView.visibleToggle()
  }
}

extension ImageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let _ = cell as? ScrollingImageCell else { return }
    if let firstVisible = collectionView.indexPathsForVisibleItems.first {
      viewModel.setSelectIndex(indexPath: firstVisible)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return view.bounds.size
  }
}

extension ImageViewController: UIGestureRecognizerDelegate {

  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let cell = collectionView.visibleCells[0] as? ScrollingImageCell,
      cell.scrollView.zoomScale == 1 {
      let v = panGR.velocity(in: nil)
      return v.y > abs(v.x)
    }
    return false
  }
}

extension ImageViewController: NotificationDelegatable {
  func notificationViewDidTap(_ notificationView: NotificationView) {
    self.dismissViewController {
      self.movingStore?()
    }
  }
}
