//
//  MediaSearchViewModelTest.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import XCTest
import Cuckoo
import RxTest
import RxSwift
@testable import MediaSearch

class MediaSearchViewModelTest: XCTestCase {

  var viewModel: MediaSearchViewModel!
  var dataSource: MockKakaoServiceType!

  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!

  override func setUp() {
    super.setUp()
    scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
    disposeBag = DisposeBag()
    dataSource = MockKakaoServiceType()
//    dataSource.setMocking(expect: ResponseFixture.sample)
    viewModel = MediaSearchViewModel(dataSource, scheduler: TestRxScheduler(scheduler))
  }

  override func tearDown() {
    super.tearDown()
  }

  func testEmptyEvent() {
    // given
    dataSource.setMocking(expect: ResponseFixture.empty)

    let isEmpty = scheduler.createObserver(Bool.self)
    viewModel.isEmpty
      .bind(to: isEmpty)
      .disposed(by: disposeBag)

    scheduler.createHotObservable([
        .next(0, ""),
        .next(50, "empty")
      ])
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)
    // when

    scheduler.start()
    // then
    XCTAssertEqual(isEmpty.events, [
        .next(50, false),
        .next(50, true)
      ])
  }
  func testLoadingEvent() {
    dataSource.setMocking()
    let isLoading = scheduler.createObserver(Bool.self)
    viewModel.isRefreshing.bind(to: isLoading).disposed(by: disposeBag)
    scheduler.start()
    viewModel.searchText.accept("loading")
    scheduler.advanceTo(1)
//    XCTAssertEqual(isLoading.events, [
//        .next(0, true)
//      ])
  }
  func testEventOnFailure() {
    let reason = "test"
    dataSource.setFailure(reason)
    let isLoading = scheduler.createObserver(Bool.self)
    let alertModel = scheduler.createObserver(UIAlertPlainViewModel?.self)
    viewModel.isRefreshing.bind(to: isLoading).disposed(by: disposeBag)
    viewModel.alertView.bind(to: alertModel).disposed(by: disposeBag)
    scheduler.start()
    viewModel.searchText.accept("loading")
    scheduler.advanceTo(1)
//    XCTAssertEqual(alertModel.events, [
//        .next(1, UIAlertPlainViewModel
//            .Builder()
//            .setMessage(message: reason)
//            .build())
//      ])
//    XCTAssertEqual(isLoading.events, [
//        .next(0, true)
//      ])
  }
}
