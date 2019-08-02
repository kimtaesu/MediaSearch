//
//  MediaSearchViewModel.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import Differentiator
import RxCocoa
import RxDataSources
import RxOptional
import RxSwift

class MediaSearchViewModel: HasDisposeBag {
  let searchText = PublishRelay<String>()

  let isEmpty = PublishRelay<Bool>()

  let hiddenRefreshConrol = PublishRelay<Bool>()
  let isEndPage = PublishRelay<Bool>()
  let isRefreshing = PublishRelay<Bool>()
  let alertView = PublishRelay<UIAlertPlainViewModel?>()
  let nextPage = PublishRelay<Bool>()
  private let isLoadMore = PublishRelay<Bool>()
  let animatedThumbnails = PublishRelay<[ThumbnailSection]>()
  let nextPageHandler: NextPageHandler
  let pageEndNotificationView = PublishRelay<NotificationModel>()
  let isVisibleLoadMore = PublishRelay<Bool>()
  let beginRefreshing = PublishRelay<Void>()
  let sectionInserted = PublishRelay<Changeset<ThumbnailSection>>()
  private var _sections: [ThumbnailSection] = []

  init(
    _ source: KakaoServiceType,
    scheduler: RxSchedulerType
  ) {
    nextPageHandler = NextPageHandler(requests: [
        .image(KakaoImageRequest()),
        .vclip(KakaoVClipRequest())
      ])
    let shareSearchText = searchText.share()

    isLoadMore
      
      .subscribe(onNext: { loadMore in
        guard self._sections.isNotEmpty else { return }
        if loadMore {
          self._sections[0].items.append(.loadMore)
          self.animatedThumbnails.accept(self._sections)
        } else {
          switch self._sections[0].items.last {
          case .loadMore?:
            self._sections[0].items.removeLast()
          default:
            break
          }
          self.animatedThumbnails.accept(self._sections)
        }
      })
      .disposed(by: disposeBag)

    let searchObservable = Observable.merge([
      shareSearchText
        .distinctUntilChanged(),
      beginRefreshing
        .withLatestFrom(shareSearchText)
      ])
      .do(onNext: self.doNextifTextEmpty(keyword:))
      .filterEmpty()

    searchObservable
      .do(onNext: self.prepareFetch(keyword:))
      .observeOn(scheduler.network)
      .flatMapLatest { [weak self] text -> Observable<[Thumbnailable]> in
        guard let self = self else { return .empty() }
        self.nextPageHandler.resetKeyword(keyword: text)
        self.isEndPage.accept(false)
        return self.getNextPpageObservable(service: source, text: text)
      }
      .observeOn(scheduler.io)
      .sortOfThubmail()
      .observeOn(scheduler.main)
      .subscribe(onNext: { [weak self] thumbnails in
        guard let self = self else { return }
        self.resetProgress()
        self.isEmpty.accept(thumbnails.isEmpty)
        if thumbnails.isNotEmpty {
          self.printDiff(thumbnails: thumbnails)
          self._sections = [ThumbnailSection(header: self.makeThumbnailHeader(), items: thumbnails)]
          self.animatedThumbnails.accept(self._sections)
        } else {
          self.animatedThumbnails.accept([])
        }
      })
      .disposed(by: disposeBag)

    nextPage
      .withLatestFrom(shareSearchText)
      .do(onNext: self.prepareFetch(keyword:))
      .observeOn(scheduler.network)
      .flatMapLatest { [weak self] text -> Observable<[Thumbnailable]> in
        guard let self = self else { return .empty() }
        return self.getNextPpageObservable(service: source, text: text)
      }
      .observeOn(scheduler.io)
      .sortOfThubmail()
      .observeOn(scheduler.main)
      .subscribe(onNext: { [weak self] thumbnails in
        guard let self = self else { return }
        assertMainThread()
        self.resetProgress()
        self.isEmpty.accept(thumbnails.isEmpty)
        self.printDiff(thumbnails: thumbnails)
        self._sections[0].items.append(contentsOf: thumbnails)
        self.animatedThumbnails.accept(self._sections)
      })
      .disposed(by: disposeBag)
  }

  private func resetProgress() {
    self.isRefreshing.accept(false)
    self.hiddenRefreshConrol.accept(false)
    self.isLoadMore.accept(false)
  }
  private func getNextPpageObservable(service: KakaoServiceType, text: String) -> Observable<[Thumbnailable]> {
    let reqeusts = self.nextPageHandler.nextPage()
    if reqeusts.isEmpty {
      resetProgress()
      isEndPage.accept(true)
      let warningImage = Asset.icRoundError36pt.image.withRenderingMode(.alwaysTemplate)
      self.pageEndNotificationView.accept(
        NotificationModel(
          title: L10n.notificationSavedToPageEndTitle,
          subtitle: "",
          body: L10n.notificationSavedToPageEndBody,
          image: warningImage,
          imageTintColor: ColorName.colorAccent
        )
      )
      return .never()
    } else {
      return service.nextImages(text, requests: reqeusts)
        .catchError(self.handlerError)
        .do(onNext: self.nextPageHandler.updatePages)
        .flatten()
    }
  }
  private func printDiff(thumbnails: [ThumbnailView]) {
    #if DEBUG
      var temp = self._sections
      temp.append(ThumbnailSection(header: self.makeThumbnailHeader(), items: thumbnails))
      do {
        let diff = try Diff.differencesForSectionedView(initialSections: self._sections, finalSections: temp)
        logger.debug("thumbnail diff: \(diff)")
      } catch {
        logger.debug("thumbnail diff error: \(error)")
      }
    #endif
  }
  private func doNextifTextEmpty(keyword: String) {
    if keyword.isEmpty {
      self.hiddenRefreshConrol.accept(false)
    }
  }
  private func prepareFetch(keyword: String) {
    self.isRefreshing.accept(true)
    self.isEmpty.accept(false)
    self.isLoadMore.accept(true)
    logger.info("emit event loading: \(true)")
    logger.info("searching keyworkd: \(keyword)")
  }

  func sections() -> [ThumbnailSection] {
    return self._sections
  }

  func getItem(_ indexPath: IndexPath) -> ThumbnailView? {
    return self._sections[indexPath.section].items[safe: indexPath.item]
  }

  func isLastestSection(_ section: Int) -> Bool {
    return section == self._sections.count - 1
  }

  @discardableResult
  private func handlerError(e: Error) -> Observable<[GenericPageThumbnail]> {
    logger.info("emit event loading: \(false)")
    let error = e as NSError
    let alertModel = UIAlertPlainViewModel
      .Builder()
      .setMessage(message: error.localizedFailureReason ?? L10n.errorUnknown)
      .setOk()
      .build()
    self.alertView.accept(alertModel)
    logger.info("an error occurred: \(e)")
    return .empty()
  }

  private func makeThumbnailHeader() -> String {
    return "Thumbnails+\(Date().timeIntervalSinceReferenceDate)"
  }
}

extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
