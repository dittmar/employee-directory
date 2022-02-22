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
   - Parameter viewModel: All of the information needed to configure this cell
   */
  func setUpCell(viewModel: EmployeeTableViewCellViewModel) {
    employeeEmailLabel.text = viewModel.email
    employeeNameLabel.text = viewModel.name
    employeePhoneLabel.text = viewModel.phone
    employeeTeamLabel.text = viewModel.teamName
    
    Task {
      let image = await viewModel.loadImage()
  
      DispatchQueue.main.async {
        // If we successfully load an image, use that.  If we don't,
        // try to use the placeholder image.  If we don't find that
        // either, just leave the image blank.
        if let image = image {
          self.employeeImageView.image = image
        } else if let image = UIImage(named: "placeholder") {
          self.employeeImageView.image = image
        } else {
          self.employeeImageView.image = nil
        }
      }
    }
  }
}
