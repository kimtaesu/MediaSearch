//
//  ImageDetailViewModel.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import Photos
import RxCocoa
import RxSwift

class ImageViewModel: HasDisposeBag {
  private let storeService: StoreServiceType

  private let _sections: [ImageSection]
  let sections: BehaviorRelay<[ImageSection]>
  let tapsFavorite = PublishRelay<Void>()
  let tapsSave = PublishRelay<Void>()

  let notificationView = PublishRelay<NotificationModel>()
  let favoriteSelected = BehaviorRelay<Bool>(value: false)
  let imageDownloaded = PublishRelay<UIImage>()
  let isLoading = PublishRelay<Bool>()
  let selectedIndexPath: BehaviorRelay<IndexPath>
  let viewDidLayoutSubviews = PublishRelay<Void>()

  let scheduler: RxSchedulerType

  init(
    store: StoreServiceType,
    sections: [ImageSection],
    selectedIndex: IndexPath,
    scheduler: RxSchedulerType
  ) {
    self._sections = sections
    self.storeService = store
    self.sections = BehaviorRelay<[ImageSection]>(value: sections)
    self.selectedIndexPath = BehaviorRelay<IndexPath>(value: selectedIndex)
    self.scheduler = scheduler
    self.setSelectIndex(indexPath: selectedIndex)

    let shareSelectedIndex = self.selectedIndexPath.share()

    tapsSave
      .observeOn(scheduler.io)
      .asObservable()
      .debug("tapsSave")
      .flatMapLatest {
        // onError 이벤트가 발생하면 Dispose 됩니다.
        return PHPhotoLibrary.rx.filterAuthorization()
          .asObservable()
          .debug("filterAuthorization")
          .catchError(self.handlerErrors(error:))
      }
      .do(onNext: { [weak isLoading] _ in
        isLoading?.accept(true)
      })
      .withLatestFrom(shareSelectedIndex)
      .flatMapLatest { indexPath -> Observable<UIImage> in
        guard let url = URL(string: sections.getThumbnailByIndex(indexPath).thumbnail_url) else { return .empty() }
        return URLSession(configuration: .default)
          .rx
          .data(request: URLRequest(url: url))
          .map { data -> UIImage? in UIImage(data: data) }
          .filterNil()
          .delay(0.7, scheduler: scheduler.io)
      }
      .catchError(self.handlerErrors(error:))
      .subscribe(onNext: { [weak self] image in
        guard let self = self else { return }
        self.isLoading.accept(false)
        logger.info("An image success to download")
        self.imageDownloaded.accept(image)
      })
      .disposed(by: disposeBag)

    tapsFavorite
      .withLatestFrom(shareSelectedIndex)
      .flatMapLatest { [weak self] ip -> Observable<Bool> in
        guard let self = self else { return Observable.just(false) }
        logger.info("taps to toggle the favorite at \(ip)")
        return self.storeService.toggle(sections.getThumbnailByIndex(ip))
      }
      .catchError(self.handlerErrors(error:))
      .subscribe(
        onNext: { [weak self] isAdded in
          guard let self = self else { return }
          logger.info("Emit Favorite is added flag \(isAdded)")
          if isAdded {
            let image = Asset.icRoundCheckCircle36pt.image.withRenderingMode(.alwaysTemplate)
            self.notificationView.accept(
              NotificationModel(
                title: L10n.notificationSavedToStoreTitle,
                subtitle: nil,
                body: L10n.notificationSavedToStoreBody,
                image: image,
                imageTintColor: ColorName.colorAccent
              )
            )
          }
          self.favoriteSelected.accept(isAdded)
        },
        onError: { error in
          logger.error(error)
        })
      .disposed(by: disposeBag)

    // 선택된 이미지로 스크롤되도록 하기 위함
    viewDidLayoutSubviews
      .withLatestFrom(self.selectedIndexPath)
      .subscribe(onNext: { [weak selectedIndexPath] selected in
        selectedIndexPath?.accept(selected)
      })
      .disposed(by: disposeBag)
  }

  private func reloadFavorite(_ image: Thumbnailable) {
    logger.info("reloadFavorite \(image)")
    self.storeService.isExist(image)
      .subscribeOn(self.scheduler.io)
      .observeOn(self.scheduler.main)
      .subscribe(onNext: { [weak favoriteSelected] exist in
        logger.info("Emit Favorite is added flag \(exist)")
        assertMainThread()
        favoriteSelected?.accept(exist)
      })
      .disposed(by: disposeBag)
  }

  func setSelectIndex(indexPath: IndexPath) {
    logger.info("setSelectIndex \(indexPath)")
    self.selectedIndexPath.accept(indexPath)
    reloadFavorite(self._sections.getThumbnailByIndex(indexPath))
  }

  private func handlerErrors<T>(error: Error) -> Observable<T> {
    logger.error(error)
    let errorImage = Asset.icRoundError36pt.image.withRenderingMode(.alwaysTemplate)
    switch error {
    case PHPhotoLibraryError.permissionDenied, PHPhotoLibraryError.permissionRestricted:
      self.notificationView.accept(
        NotificationModel(
          title: "권환 확인",
          subtitle: "사진앱에 접근할 수 없습니다.",
          body: "권한을 확인해 주세요.",
          image: errorImage,
          imageTintColor: ColorName.errorColor)
      )
    default:
      self.notificationView.accept(
        NotificationModel(
          title: "오류",
          subtitle: "오류가 발생하였습니다.",
          image: errorImage,
          imageTintColor: ColorName.errorColor)
      )
    }
    return .never()
  }
}
