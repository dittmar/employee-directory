//
//  Api.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 2/21/22.
//
//  A centralized place where we can register all of the API
//  calls for the app.
//

import EmployeeDirectoryApi
import Foundation

class Api {
  static let shared = Api()
  
  /// Endpoint that uses EmployeeDirectoryApi to fetch a list of employees
  /// - Returns: employees response
  func fetchEmployees() async throws -> GetEmployeesEndpoint.Response {
    try await GetEmployeesEndpoint.getEmployees.invoke()
  }
  
  // TODO (dittmar): this isn't production code.  It's just
  // to facilitate testing the empty response scenario
  func fetchEmployeesEmpty() async throws -> GetEmployeesEndpoint.Response {
    try await GetEmployeesEndpoint.getEmptyEmployees.invoke()
  }
  
  // TODO (dittmar): this isn't production code.  It's just
  // to facilitate testing the malformed response scenario
  func fetchEmployeesMalformed() async throws -> GetEmployeesEndpoint.Response {
    try await GetEmployeesEndpoint.getMalformedEmployees.invoke()
  }
}
