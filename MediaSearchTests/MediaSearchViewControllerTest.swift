//
//  MediaSearchViewControllerTest.swift
//  MediaSearchTests
//
//  Created by tskim on 02/08/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import XCTest
import RxTest

@testable import MediaSearch

class MediaSearchViewControllerTest: XCTestCase {

  var viewController: MediaSearchViewController!
  var viewModel: MediaSearchViewModel!
  var kakaoService: MockKakaoServiceType!
  var testScheduler: TestScheduler!

  override func setUp() {
    super.setUp()

    testScheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
    kakaoService = MockKakaoServiceType()
    viewModel = MediaSearchViewModel(kakaoService, scheduler: TestRxScheduler(testScheduler))
    viewController = MediaSearchViewController(viewModel: viewModel, scheduler: TestRxScheduler(testScheduler))
    _ = viewController.view
    viewController.viewWillAppear(true)
  }

  func testLoadCell() {
    viewController.view.layoutIfNeeded()
    kakaoService.setMocking(expect: ResponseFixture.sample)
    viewModel.searchText.accept("A")
    testScheduler.advanceTo(1)
    let cell = viewController.dataSource.collectionView(viewController.thumbnailsCollectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? ThumbnailCell
    XCTAssertNotNil(cell?.thumbnail)
  }
}
