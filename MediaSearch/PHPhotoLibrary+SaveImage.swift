//
//  PHPhotoLibrary+SaveImage.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Photos
import UIKit

extension PHPhotoLibrary {
  func savePhoto(image: UIImage, albumName: String, completion: ((Result<PHAsset?, Error>) -> Void)? = nil) {
    func save() {
      if let album = PHPhotoLibrary.shared().findAlbum(albumName: albumName) {
        PHPhotoLibrary.shared().saveImage(image: image, album: album, completion: completion)
      } else {
        PHPhotoLibrary.shared().createAlbum(albumName: albumName, completion: { collection in
          if let collection = collection {
            PHPhotoLibrary.shared().saveImage(image: image, album: collection, completion: completion)
          } else {
            completion?(Result.failure(AppError.createAlbum))
          }
        })
      }
    }

    if PHPhotoLibrary.authorizationStatus() == .authorized {
      save()
    } else {
      PHPhotoLibrary.requestAuthorization({ status in
        if status == .authorized {
          save()
        }
      })
    }
  }

  // MARK: - Private

  fileprivate func findAlbum(albumName: String) -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
    let fetchResult: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    guard let photoAlbum = fetchResult.firstObject else {
      return nil
    }
    return photoAlbum
  }

  fileprivate func createAlbum(albumName: String, completion: @escaping (PHAssetCollection?) -> Void) {
    var albumPlaceholder: PHObjectPlaceholder?
    PHPhotoLibrary.shared().performChanges({
      let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
      albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
    }, completionHandler: { success, error in
        if success {
          guard let placeholder = albumPlaceholder else {
            completion(nil)
            return
          }
          let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
          guard let album = fetchResult.firstObject else {
            completion(nil)
            return
          }
          completion(album)
        } else {
          completion(nil)
        }
      })
  }

  fileprivate func saveImage(image: UIImage, album: PHAssetCollection, completion: ((Result<PHAsset?, Error>) -> Void)? = nil) {
    var placeholder: PHObjectPlaceholder?
    PHPhotoLibrary.shared().performChanges({
      let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
      guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
        let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
      placeholder = photoPlaceholder
      let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
      albumChangeRequest.addAssets(fastEnumeration)
    }, completionHandler: { success, error in
        guard let placeholder = placeholder else {
          completion?(Result.success(nil))
          return
        }
        if success {
          let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
          let asset: PHAsset? = assets.firstObject
          completion?(Result.success(asset))
        } else {
          completion?(Result.failure(AppError.savePhoto))
        }
      })
  }
}
