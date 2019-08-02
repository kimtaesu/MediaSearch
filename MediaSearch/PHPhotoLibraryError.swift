//
//  PHPhotoLibraryError.swift
//  MediaSearch
//
//  Created by tskim on 27/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import Photos

enum PHPhotoLibraryError: Error {
  case permissionDenied(PHAuthorizationStatus)
  case permissionRestricted(PHAuthorizationStatus)
  case unknown(PHAuthorizationStatus)
}
