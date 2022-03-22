//
//  EmployeeDetailViewController.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 3/22/22.
//

import EmployeeDirectoryApi
import UIKit

final class EmployeeDetailViewController: UIViewController {
  @IBOutlet private weak var employeeImageView: UIImageView!
  
  @IBOutlet private weak var biographyLabel: UILabel!
  @IBOutlet private weak var teamLabel: UILabel!
  
 
  @IBOutlet private weak var emailButton: UIButton!
  
  @IBOutlet private weak var employeeTypeLabel: UILabel!
 
  @IBOutlet private weak var phoneButton: UIButton!
  @IBOutlet private weak var phoneStack: UIStackView!
  
  private let employee: Employee
  
  init(employee: Employee) {
    self.employee = employee
    
    super.init(nibName: String(describing: Self.self), bundle: .main)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = employee.fullName
    
    let placeholderImage = UIImage(named: "placeholder")
    
    if let urlString = employee.largePhotoUrlString {
      let url = URL(string: urlString)
      employeeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
    } else {
      employeeImageView.image = placeholderImage
    }
    
    biographyLabel.text = employee.biography
    biographyLabel.isHidden = employee.biography == nil
    
    teamLabel.text = employee.team.rawValue
    employeeTypeLabel.text = employee.employeeType.rawValue
    
    if let phone = employee.phoneNumber {
      phoneButton.setTitle(phone, for: .normal)
      phoneStack.isHidden = false
    } else {
      phoneStack.isHidden = true
    }
    
    emailButton.setTitle(employee.emailAddress, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction private func tappedPhone(_ sender: Any) {
    guard let phone = employee.phoneNumber,
          let url = URL(string: "tel:\(phone)") else {
      return
    }
    
    UIApplication.shared.open(url)
  }
  
  @IBAction private func tappedEmail(_ sender: Any) {
    guard let url = URL(string: "mailto:\(employee.emailAddress)") else {
      return
    }
    
    UIApplication.shared.open(url)
  }
}
