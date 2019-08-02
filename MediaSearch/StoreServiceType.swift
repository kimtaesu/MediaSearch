//
//  StoreServiceType.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

protocol StoreServiceType {
  func toggle(_ image: Thumbnailable) -> Observable<Bool>
  func isExist(_ image: Thumbnailable) -> Observable<Bool>
  func fetchFavorites() -> Observable<[Thumbnailable]>
}
