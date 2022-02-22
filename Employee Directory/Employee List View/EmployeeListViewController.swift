//
//  EmployeeListViewController.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/13/22.
//
//  Lists all of the employees for the employee directory
//

import UIKit
import EmployeeDirectoryApi

final class EmployeeListViewController: UIViewController {
  private lazy var employeeListViewModel = EmployeeListViewModel(delegate: self)
  
  @IBOutlet private weak var employeeTableView: UITableView!
  @IBOutlet private weak var errorView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    employeeTableView.dataSource = self
    employeeTableView.delegate = self
    employeeTableView.refreshControl = UIRefreshControl()
    employeeTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    
    employeeTableView.register(UINib(nibName: String(describing: EmployeeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EmployeeTableViewCell.self))
    
    loadEmployees(type: .empty)
  }
  
  // User tapped retry, so try loading employees again
  @IBAction private func tappedRetry(_ sender: Any) {
    loadEmployees()
  }
  
  // TODO (dittmar): This only exists to make it easier for people reviewing this app to test an empty response without messing around with the code
  @IBAction private func tappedRetryEmpty(_ sender: Any) {
    loadEmployees(type: .empty)
  }
  
  // TODO (dittmar): This only exists to make it easier for people reviewing this app to test a malformed response without messing around with the code
  @IBAction private func tappedRetryMalformed(_ sender: Any) {
    loadEmployees(type: .malformed)
  }
  
  @objc private func handleRefresh() {
    loadEmployees()
    
    DispatchQueue.main.async {
      self.employeeTableView.refreshControl?.endRefreshing()
    }
  }
  
  // Load the employees from the server
  private func loadEmployees(type: EmployeeListViewModel.EndpointType = .normal) {
    Task {
      try await employeeListViewModel.fetchEmployees(type: type)
    }
  }
}

extension EmployeeListViewController: UITableViewDelegate {}

extension EmployeeListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    employeeListViewModel.employees.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmployeeTableViewCell.self)) as? EmployeeTableViewCell else {
      return UITableViewCell()
    }
    
    let viewModel = EmployeeTableViewCellViewModel(employee: employeeListViewModel.employees[indexPath.row])
    cell.setUpCell(viewModel: viewModel)
    
    return cell
  }
}

extension EmployeeListViewController: EmployeeListViewModelDelegate {
  func didUpdateEmployees() {
    let hasEmployees = !employeeListViewModel.employees.isEmpty
    DispatchQueue.main.async {
      // If we have employees, we should show the list view.
      // Otherwise, we should show the error view
      self.employeeTableView.isHidden = !hasEmployees
      self.errorView.isHidden = hasEmployees
      self.employeeTableView.reloadData()
    }
  }
}
