//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//

import EmployeeDirectoryApi
import Foundation

protocol EmployeeListViewModelDelegate: AnyObject {
  func didUpdateEmployees()
}

final class EmployeeListViewModel {
  private weak var delegate: EmployeeListViewModelDelegate?
  private(set) var employees = [Employee]()
  
  init(delegate: EmployeeListViewModelDelegate?) {
    self.delegate = delegate
  }
  
  /// Update the list of employees from the server and notify the UI that employees has been updated
  func fetchEmployees() async {
    do {
      let response = try await GetEmployeesEndpoint.getEmployees.invoke()

      employees = response?.employees ?? []
      delegate?.didUpdateEmployees()
    } catch {
      // TODO (dittmar): Handle error response
    }
  }
}
