//
//  KakaoRemoteSourceType.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

protocol KakaoServiceType {
  func nextImages(_ keyword: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]>
}
