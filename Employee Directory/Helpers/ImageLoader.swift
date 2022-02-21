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

class ImageLoader {
  static let shared = ImageLoader()
  /**
   Load an image at the given URL
   - Parameters:
    - imageUrl: The URL where the image is located
    - completion: What to do after the loading operation is complete, whether it was successful or not
   */
  func loadImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
    SDWebImageManager.shared.loadImage(with: imageUrl, options: .scaleDownLargeImages, progress: nil) { image, _, error, _, _, _ in
      if let image = image, error == nil {
        completion(.success(image))
      } else {
        completion(.failure(error!))
      }
    }
  }
}
