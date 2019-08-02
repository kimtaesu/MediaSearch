//
//  PHPhotoLibrary+Rx.swift
//  MediaSearch
//
//  Created by tskim on 27/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import Photos
import RxCocoa
import RxSwift

extension Reactive where Base: PHPhotoLibrary {
  static func filterAuthorization() -> Single<PHAuthorizationStatus> {
    return Single.create { observer in
      let status = PHPhotoLibrary.authorizationStatus()
      switch status {
      case .authorized:
        observer(.success(status))
      case .denied:
        observer(.error(PHPhotoLibraryError.permissionDenied(status)))
      case .restricted:
        observer(.error(PHPhotoLibraryError.permissionRestricted(status)))
      case .notDetermined:
        PHPhotoLibrary.requestAuthorization { status in
          observer(.success(status))
        }
      @unknown default:
        observer(.error(PHPhotoLibraryError.unknown(status)))
      }
      return Disposables.create()
    }
  }
}
