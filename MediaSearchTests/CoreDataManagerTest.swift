//
//  CoreDataManagerTest.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import XCTest
@testable import MediaSearch

class CoreDataManagerTest: XCTestCase {
  var coreDataManager: CoreDataManager!

  override func setUp() {
    super.setUp()
    coreDataManager = CoreDataManager.shared
    coreDataManager.flushData()
    
  }

  override func tearDown() {
    super.tearDown()
    coreDataManager.flushData()
  }

  func testInsertionForFavorite() {
    let expect = KakaoImageFixtrue.random

    coreDataManager.insertFavorite(expect)
    let favorites = coreDataManager.fetchFavorites()

    XCTAssertEqual(1, favorites.count)
    XCTAssertTrue(expect == favorites.first)
  }
  func testDeletionForFavorite() {
    let first = coreDataManager.insertFavorite(ResponseFixture.sample.documents[0])!
    let second = coreDataManager.insertFavorite(ResponseFixture.sample.documents[1])!

    coreDataManager.delete(favorite: second)
    let favorites = coreDataManager.fetchFavorites()

    XCTAssertEqual(1, favorites.count)
    XCTAssertTrue(first == favorites.first)
  }
  func testDuplicatedInsertionForFavorite() {
    let expect = KakaoImageFixtrue.random

    // 같은 객체를 두번 저장
    coreDataManager.insertFavorite(expect)
    coreDataManager.insertFavorite(expect)
    let favorites = coreDataManager.fetchFavorites()

    // 하나의 결과만 있어야함
    XCTAssertEqual(1, favorites.count)
    XCTAssertTrue(expect == favorites.first)
  }
}

