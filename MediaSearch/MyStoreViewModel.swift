//
//  StoreViewModel.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MyStoreViewModel: HasDisposeBag {
  let fetchFavorites = PublishRelay<Bool>()
  let loading = PublishRelay<Bool>()
  let isEmpty = PublishRelay<Bool>()
  let sections = PublishRelay<[ImageSection]>()
  private var _sections: [ImageSection] = []

  init(service: StoreServiceType, scheduler: RxScheduler = RxScheduler()) {
    fetchFavorites
      .do(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.loading.accept(true)
        self.isEmpty.accept(false)
      })
      .observeOn(scheduler.io)
      .flatMapLatest { _ in
        service.fetchFavorites()
      }
      .observeOn(scheduler.main)
      .subscribe(
        onNext: { [weak self] result in
          guard let self = self else { return }
          assertMainThread()
          let items = result.map { $0.concreateThumbnail }
          self.loading.accept(false)
          self.isEmpty.accept(result.isEmpty)
          self._sections = [ImageSection(header: "thumbnails", items: items)]
          self.sections.accept(self._sections)
        },
        onError: { error in
          self.loading.accept(false)
        })
      .disposed(by: disposeBag)
  }

  func getItem(indexPath: IndexPath) -> Thumbnailable {
    return self._sections[indexPath.section].items[indexPath.row]
  }
  func allSections() -> [ImageSection] {
    return self._sections
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
