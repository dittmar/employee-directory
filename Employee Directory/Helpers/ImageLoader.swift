//
//  ImageLoader.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//
//  A simple image loader class that uses `SDWebImage` under the hood
//

import Foundation
import SDWebImage
import UIKit

protocol ImageLoader {
  /**
   Load an image at the given URL
   - Parameters:
    - imageUrl: The URL where the image is located
    - completion: What to do after the loading operation is complete, whether it was successful or not
   */
  func loadImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

struct ImageLoaderImpl {
  enum ImageLoaderError {
    static let messageKey = "message"
    case missingImage
    
    var error: NSError {
      NSError(domain: String(describing: Self.self), code: code, userInfo: [Self.messageKey: message])
    }
    
    var code: Int {
      switch self {
      case .missingImage:
        return -1
      }
    }
    
    var message: String {
      switch self {
      case .missingImage:
        return "Image unexpectedly missing"
      }
    }
  }
  
  static let shared = ImageLoaderImpl()
  
  // Used to facilitate dependency injection for unit testing
  private let imageManager: SDWebImageManager
  
  init(imageManager: SDWebImageManager = .shared) {
    self.imageManager = imageManager
  }
}

extension ImageLoaderImpl: ImageLoader {
  func loadImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    imageManager.loadImage(with: imageUrl, options: .scaleDownLargeImages, progress: nil) { image, _, error, _, _, _ in
      if let image = image, error == nil {
        completion(.success(image))
      } else if let error = error {
        completion(.failure(error))
      } else {
        completion(.failure(ImageLoaderError.missingImage.error))
      }
    }
  }
}
