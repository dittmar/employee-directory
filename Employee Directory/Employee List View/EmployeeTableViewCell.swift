//
//  EmployeeTableViewCell.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//

import EmployeeDirectoryApi
import UIKit

final class EmployeeTableViewCell: UITableViewCell {
  @IBOutlet private weak var employeeEmailLabel: UILabel!
  @IBOutlet private weak var employeeImageView: UIImageView!
  @IBOutlet private weak var employeeNameLabel: UILabel!
  @IBOutlet private weak var employeePhoneLabel: UILabel!
  @IBOutlet private weak var employeeTeamLabel: UILabel!
  
  func setUpCell(employee: Employee) {
    employeeEmailLabel.text = employee.emailAddress
    employeeNameLabel.text = employee.fullName
    employeePhoneLabel.text = employee.phoneNumber ?? NSLocalizedString("NoEmployeePhone", comment: "No phone provided")
    employeeTeamLabel.text = employee.team.rawValue
  }
}
