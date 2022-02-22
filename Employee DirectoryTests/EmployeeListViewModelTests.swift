//
//  EmployeeListViewModelTests.swift
//  Employee DirectoryTests
//
//  Created by Kevin Dittmar on 2/21/22.
//

import EmployeeDirectoryApi
import XCTest
@testable import Employee_Directory

final class EmployeeListViewModelTests: XCTestCase {
  private var didUpdateEmployeesCallCount = 0
  
  class MockApi: Api {
    static let malformedEmployeesErrorDomain = "MalformedEmployeesError"
    static let malformedEmployeesErrorCode = -1
    
    override func fetchEmployees() async throws -> GetEmployeesEndpoint.Response {
      let employeesJsonData = Data("""
      {
        "employees" : [
          {
            "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",

            "full_name" : "Camille Rogers",
            "phone_number" : "5558531970",
            "email_address" : "crogers.demo@squareup.com",
            "biography" : "Designer on the web marketing team.",

            "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/small.jpg",
            "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/5095a907-abc9-4734-8d1e-0eeb2506bfa8/large.jpg",

            "team" : "Public Web & Marketing",
            "employee_type" : "PART_TIME"
          }
        ]
      }
      """.utf8)
      return try JSONDecoder().decode(GetEmployeesEndpoint.Response.self, from: employeesJsonData)
    }
    
    override func fetchEmployeesEmpty() async throws -> GetEmployeesEndpoint.Response {
      let employeesJsonData = Data("""
      {
        "employees" : []
      }
      """.utf8)
      return try JSONDecoder().decode(GetEmployeesEndpoint.Response.self, from: employeesJsonData)
    }
    
    override func fetchEmployeesMalformed() async throws -> GetEmployeesEndpoint.Response {
      throw NSError(domain: Self.malformedEmployeesErrorDomain, code: Self.malformedEmployeesErrorCode)
    }
  }
  
  func testFetchEmployees() async throws {
    let viewModel = EmployeeListViewModel(delegate: self, api: MockApi())
    
    try await viewModel.fetchEmployees(type: .normal)
    
    XCTAssertEqual(1, didUpdateEmployeesCallCount)
    XCTAssertEqual(1, viewModel.employees.count)
    XCTAssertEqual("Camille Rogers", viewModel.employees.first?.fullName)
  }
  
  func testFetchEmployeesMalformed() async throws {
    let viewModel = EmployeeListViewModel(delegate: self, api: MockApi())
    do {
      try await viewModel.fetchEmployees(type: .malformed)
      XCTFail()
    } catch {
      XCTAssertEqual(MockApi.malformedEmployeesErrorDomain, (error as NSError).domain)
      XCTAssertEqual(MockApi.malformedEmployeesErrorCode, (error as NSError).code)
    }
  }
  
  func testFetchEmployeesEmpty() async throws {
    let viewModel = EmployeeListViewModel(delegate: self, api: MockApi())
    
    try await viewModel.fetchEmployees(type: .empty)
    
    XCTAssertEqual(1, didUpdateEmployeesCallCount)
    XCTAssertTrue(viewModel.employees.isEmpty)
  }
}

extension EmployeeListViewModelTests: EmployeeListViewModelDelegate {
  func didUpdateEmployees() {
    didUpdateEmployeesCallCount += 1
  }
}
