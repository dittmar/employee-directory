//
//  EmployeeListViewModel.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//  View model for the employee list view
//

import EmployeeDirectoryApi
import Foundation

protocol EmployeeListViewModelDelegate: AnyObject {
  func didUpdateEmployees()
}

final class EmployeeListViewModel {
  /// Meant to facilitate testing of this app by people reviewing it
  enum EndpointType {
    case normal
    case empty
    case malformed
  }
  
  private let api: Api
  private weak var delegate: EmployeeListViewModelDelegate?
  private(set) var employees = [Employee]()
  
  init(delegate: EmployeeListViewModelDelegate?, api: Api = .shared) {
    self.delegate = delegate
    self.api = api
  }
  
  /** Update the list of employees from the server and notify the UI that employees has been updated
   - Parameter type: the version of the `GetEmployeesEndpoint` to call.  This parameter wouldn't exist in a production version of this app.  It's only here to make it easier for reviewers to test the non-success scenarios
   */
  func fetchEmployees(type: EndpointType) async throws {
    let response: GetEmployeesEndpoint.Response
    switch type {
    case .normal:
      response = try await api.fetchEmployees()
    case .empty:
      response = try await api.fetchEmployeesEmpty()
    case .malformed:
      response = try await api.fetchEmployeesMalformed()
    }

    employees = response.employees
    delegate?.didUpdateEmployees()
  }
}
