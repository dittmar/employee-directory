//
//  EmployeeTableViewCell.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//
//  Displays the information for a single employee, including name, email, and team.
//  Phone number and photo are also shown if they are available
//

import EmployeeDirectoryApi
import UIKit
import SDWebImage

final class EmployeeTableViewCell: UITableViewCell {
  
  @IBOutlet private weak var employeeEmailLabel: UILabel!
  @IBOutlet private weak var employeeImageView: UIImageView!
  @IBOutlet private weak var employeeNameLabel: UILabel!
  @IBOutlet private weak var employeePhoneLabel: UILabel!
  @IBOutlet private weak var employeeTeamLabel: UILabel!
  
  /**
   Configure the cell with a new employee's information
   - Parameter employee: An `Employee` from the server that will be used to configure the cell's display info
   */
  func setUpCell(employee: Employee, imageLoader: ImageLoader = .shared) {
    employeeEmailLabel.text = employee.emailAddress
    employeeNameLabel.text = employee.fullName
    employeePhoneLabel.text = employee.phoneNumber ?? NSLocalizedString("NoEmployeePhone", comment: "No phone provided")
    employeeTeamLabel.text = employee.team.rawValue
    
    if let imageUrlString = employee.smallPhotoUrlString,
       let imageUrl = URL(string: imageUrlString) {
      
      imageLoader.loadImage(imageUrl: imageUrl) { [weak self] result in
        DispatchQueue.main.async {
          switch result {
          case let .success(image):
            self?.updateImage(image)
          case .failure:
            // TODO (dittmar): we might want to report the error somewhere (e.g., Crashlytics, Sentry.io, etc)
            
            // For some reason, we don't have an employee photo, so unset the image view
            self?.updateImage(nil)
          }
        }
      }
    } else {
      // If we don't have a valid image URL, make sure the image view returns to an empty state
      updateImage(nil)
    }
  }
  
  /**
   Set the employee image if we have one and set a placeholder if we don't
   - Parameter image: The `UIImage` to set as the employee's photo or `nil` if the employee doesn't have a photo
   */
  private func updateImage(_ image: UIImage?) {
    // If we have an image, use it.  If we don't, use the placeholder.  If we can't
    // find the placeholder for some reason, just set the image to nil
    if let image = image {
      employeeImageView.image = image
    } else if let image = UIImage(named: "placeholder") {
      employeeImageView.image = image
    } else {
      employeeImageView.image = nil
    }
  }
}
