//
//  NextPageHandler.swift
//  MediaSearch
//
//  Created by tskim on 22/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NextPageHandler {

  private var imageRequests: [ImageRequest: (searchOption: SearchOption, isEnd: Bool)] = [:]

  init(requests: [ImageRequest]) {
    requests.forEach {
      imageRequests[$0] = (SearchOption(query: ""), false)
    }
  }

  func nextPage() -> [(ImageRequest, SearchOption)] {
    #if DEBUG
      imageRequests
        .filter { !$0.value.isEnd }
        .forEach {
          logger.verbose("nextPage: [\($0.key):\($0.value)]")
      }
    #endif

    return imageRequests
      .filter { !$0.value.isEnd }
      .flatMap { [$0.key: $0.value.searchOption] }
  }

  func resetKeyword(keyword: String) {
    logger.verbose("resetKeyword set keyword: \(keyword)")
    imageRequests.forEach {
      let value = (SearchOption(query: keyword), false)
      imageRequests.updateValue(value, forKey: $0.key)
    }
  }

  func getSearchOption(request: ImageRequest) -> SearchOption? {
    return imageRequests[request]?.searchOption
  }
  func updatePages(responses: [GenericPageThumbnail]) {
    responses.forEach {
      if let nextPage = $0.nextPage, isLastPageKakaobug(itemSize: $0.documents.count) {
        imageRequests[$0.request]?.searchOption.page = nextPage
        logger.verbose("set nextPage of \($0.request) to \(String(describing: imageRequests[$0.request]?.searchOption.page))")
      } else {
        imageRequests[$0.request]?.isEnd = true
        logger.verbose("nextPage hit end \($0.request)")
      }
    }
  }
  private func isLastPageKakaobug(itemSize size: Int) -> Bool {
    return SearchOption.PAGE_SIZE <= size
  }
}
