//
//  ImageLoaderTests.swift
//  Employee DirectoryTests
//
//  Created by Kevin Dittmar on 2/21/22.
//

import SDWebImage
import XCTest
@testable import Employee_Directory

final class ImageLoaderTests: XCTestCase {
  func testLoadImageSuccess() {
    /// Make a mock image manager that completes with an image and no error regardless
    class MockImageManager: SDWebImageManager {
      override func loadImage(with url: URL?, options: SDWebImageOptions = [], progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        completedBlock(.checkmark, nil, nil, .all, true, nil)
        return nil
      }
    }
    
    let imageLoader = ImageLoaderImpl(imageManager: MockImageManager())
    
    imageLoader.loadImage(imageUrl: URL(string: "www.example.com")!) { result in
      // We're expecting load image to succeed with a checkmark image
      switch result {
      case let .success(image):
        XCTAssertEqual(.checkmark, image)
      case .failure(_):
        XCTFail()
      }
    }
  }
  
  func testLoadImageFailureNoImageNoError() {
    /// Make a mock image manager that completes with a nil image regardless
    class MockImageManager: SDWebImageManager {
      override func loadImage(with url: URL?, options: SDWebImageOptions = [], progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        completedBlock(nil, nil, nil, .all, true, nil)
        return nil
      }
    }
    
    let imageLoader = ImageLoaderImpl(imageManager: MockImageManager())
    
    imageLoader.loadImage(imageUrl: URL(string: "www.example.com")!) { result in
      // We're expecting load image to fail with no error
      switch result {
      case .success:
        XCTFail()
      case let .failure(error):
        XCTAssertEqual(ImageLoaderImpl.ImageLoaderError.missingImage.code, (error as NSError).code)
        XCTAssertEqual(ImageLoaderImpl.ImageLoaderError.missingImage.message, (error as NSError).userInfo[ImageLoaderImpl.ImageLoaderError.messageKey] as! String)
      }
    }
  }
  
  func testLoadImageFailureError() {
    /// Make a mock image manager that completes with  an error and an image regardless
    class MockImageManager: SDWebImageManager {
      static let errorCode = -1
      static let errorDomain = "ImageLoadingError"
      
      override func loadImage(with url: URL?, options: SDWebImageOptions = [], progress progressBlock: SDImageLoaderProgressBlock?, completed completedBlock: @escaping SDInternalCompletionBlock) -> SDWebImageCombinedOperation? {
        completedBlock(.checkmark, nil, NSError(domain: Self.errorDomain, code: Self.errorCode, userInfo: nil), .all, true, nil)
        return nil
      }
    }
    
    let imageLoader = ImageLoaderImpl(imageManager: MockImageManager())
    
    imageLoader.loadImage(imageUrl: URL(string: "www.example.com")!) { result in
      // We're expecting load image to fail with an error
      switch result {
      case .success:
        XCTFail()
      case let .failure(error):
        XCTAssertEqual(MockImageManager.errorCode, (error as NSError).code)
        XCTAssertEqual(MockImageManager.errorDomain, (error as NSError).domain)
      }
    }
  }
}
