//
//  EmployeeListViewController.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/13/22.
//

import UIKit

final class EmployeeListViewController: UIViewController {
  private lazy var employeeListViewModel = EmployeeListViewModel(delegate: self)
  
  @IBOutlet private weak var employeeTableView: UITableView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    employeeTableView.dataSource = self
    employeeTableView.delegate = self
    employeeTableView.refreshControl = UIRefreshControl()
    employeeTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    
    employeeTableView.register(UINib(nibName: String(describing: EmployeeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EmployeeTableViewCell.self))
    
    loadEmployees()
  }
  
  @objc private func handleRefresh() {
    loadEmployees()
    
    DispatchQueue.main.async {
      self.employeeTableView.refreshControl?.endRefreshing()
    }
  }
  
  // Load the employees from the server
  private func loadEmployees() {
    Task {
      await employeeListViewModel.fetchEmployees()
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
    
    cell.setUpCell(employee: employeeListViewModel.employees[indexPath.row])
    
    return cell
  }
}

extension EmployeeListViewController: EmployeeListViewModelDelegate {
  func didUpdateEmployees() {
    DispatchQueue.main.async {
      self.employeeTableView.reloadData()
    }
  }
}
