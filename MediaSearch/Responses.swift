//
//  Responses.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

struct Meta: Decodable, Equatable {
  private let total_count: Int
  let pageable_count: Int
  let is_end: Bool
}

extension Meta {
  static let metaEnd = Meta(total_count: 0, pageable_count: 0, is_end: true)

  static func fallback(nextPage: Int) -> Meta {
    return Meta(total_count: Int.max, pageable_count: Int.max, is_end: false)
  }
}

protocol KakaoResponsable {
  associatedtype DATA where DATA: Decodable, DATA: Thumbnailable

  var meta: Meta { get }
  var documents: [DATA] { get }
  // custom field
  var nextPage: Int? { get set }
}

extension KakaoResponsable {
  func toGenericThumbnail(request: ImageRequest) -> GenericPageThumbnail {
    return GenericPageThumbnail(request: request, meta: self.meta, nextPage: self.nextPage, documents: self.documents)
  }
}

struct KakaoImageResponse: Decodable, KakaoResponsable {
  let meta: Meta
  let documents: [KakaoImage]
  var nextPage: Int?

  public init(meta: Meta, documents: [KakaoImage], nextPage: Int? = nil) {
    self.meta = meta
    self.documents = documents
    self.nextPage = nextPage
  }
}

struct KakaoVClipResponse: Decodable, KakaoResponsable {
  let meta: Meta
  let documents: [KakaoVClip]
  var nextPage: Int?

  public init(meta: Meta, documents: [KakaoVClip], nextPage: Int? = nil) {
    self.meta = meta
    self.documents = documents
    self.nextPage = nextPage
  }
}
