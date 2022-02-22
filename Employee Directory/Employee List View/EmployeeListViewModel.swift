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
  /// Meant to facilitate testing of this app by people reviewing it
  enum EndpointType {
    case normal
    case empty
    case malformed
  }
  
  private weak var delegate: EmployeeListViewModelDelegate?
  private(set) var employees = [Employee]()
  
  init(delegate: EmployeeListViewModelDelegate?) {
    self.delegate = delegate
  }
  
  /// Update the list of employees from the server and notify the UI that employees has been updated
  func fetchEmployees(type: EndpointType) async throws {
    // TODO (dittmar): this switch isn't production code.  This is just meant
    // to make it easier for anyone reviewing this app to see all the error states
    let endpoint: GetEmployeesEndpoint
    switch type {
    case .normal:
      endpoint = .getEmployees
    case .empty:
      endpoint = .getEmptyEmployees
    case .malformed:
      endpoint = .getMalformedEmployees
    }
    
    let response = try await endpoint.invoke()

    employees = response?.employees ?? []
    delegate?.didUpdateEmployees()
  }
}
