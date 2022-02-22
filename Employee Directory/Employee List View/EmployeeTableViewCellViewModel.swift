//
//  EmployeeTableViewCellViewModel.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//
//  View model for an individual cell in the employee list view
//

import EmployeeDirectoryApi
import Foundation
import UIKit

final class EmployeeTableViewCellViewModel {
  private(set) var email: String
  private(set) var imageUrlString: String?
  private(set) var name: String
  private(set) var phone: String
  private(set) var teamName: String
  
  init(employee: Employee) {
    email = employee.emailAddress
    imageUrlString = employee.smallPhotoUrlString
    name = employee.fullName
    phone = employee.phoneNumber ?? NSLocalizedString("NoEmployeePhone", comment: "No phone provided")
    teamName = employee.team.rawValue
  }
  
  /**
   Loads the image from the URL we have on the `Employee`
   - Parameter imageLoader: The `ImageLoader` to use to load the image from its URL
   - Returns: The `UIImage` associated with the `Employee`'s photo URL
   */
  func loadImage(imageLoader: ImageLoader = ImageLoaderImpl.shared) async -> UIImage? {
    if let urlString = imageUrlString,
       let imageUrl = URL(string: urlString) {
      
      let result = await withUnsafeContinuation { c in
        imageLoader.loadImage(imageUrl: imageUrl) { result in
          c.resume(returning: result)
        }
      }
      
      switch result {
      case let .success(image):
        return image
      case .failure:
        // TODO (dittmar): we might want to report the error somewhere (e.g., Crashlytics, Sentry.io, etc)
        
        // For some reason, we don't have an employee photo, so unset the image view
        return nil
      }
    } else {
      return nil
    }
  }
}
