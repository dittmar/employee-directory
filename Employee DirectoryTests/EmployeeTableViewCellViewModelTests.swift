//
//  EmployeeTableViewCellViewModelTests.swift
//  Employee DirectoryTests
//
//  Created by Kevin Dittmar on 2/21/22.
//

import EmployeeDirectoryApi
import XCTest
@testable import Employee_Directory

final class EmployeeTableViewCellViewModelTests: XCTestCase {
  struct MockImageLoader: ImageLoader {
    /// Controls whether the mock `loadImage` returns an image or throws an error
    let shouldSucceed: Bool
    
    func loadImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
      if shouldSucceed {
        completion(.success(.checkmark))
      } else {
        completion(.failure(ImageLoaderImpl.ImageLoaderError.missingImage.error))
      }
    }
  }
  
  func testInitWithPhone() throws {
    let employeeJsonData = Data("""
    {
      "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",
      "full_name" : "Camille Rogers",
      "phone_number" : "5558531970",
      "email_address" : "crogers.demo@squareup.com",
      "team" : "Public Web & Marketing",
      "employee_type" : "PART_TIME"
    }
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    XCTAssertEqual(employee.fullName, viewModel.name)
    XCTAssertEqual(employee.emailAddress, viewModel.email)
    XCTAssertEqual(employee.team.rawValue, viewModel.teamName)
    XCTAssertEqual(employee.phoneNumber, viewModel.phone)
  }
  
  func testInitNoPhone() throws {
    let employeeJsonData = Data("""
    {
      "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",
      "full_name" : "Camille Rogers",
      "email_address" : "crogers.demo@squareup.com",
      "team" : "Public Web & Marketing",
      "employee_type" : "PART_TIME"
    }
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    XCTAssertEqual(employee.fullName, viewModel.name)
    XCTAssertEqual(employee.emailAddress, viewModel.email)
    XCTAssertEqual(employee.team.rawValue, viewModel.teamName)
    XCTAssertEqual(NSLocalizedString("NoEmployeePhone", comment: ""), viewModel.phone)
  }
  
  func testLoadImage() async throws {
    let employeeJsonData = Data("""
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
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    
    let image = await viewModel.loadImage(imageLoader: MockImageLoader(shouldSucceed: true))
    
    XCTAssertEqual(.checkmark, image)
  }
  
  func testLoadImageNoUrl() async throws {
    let employeeJsonData = Data("""
    {
      "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",

      "full_name" : "Camille Rogers",
      "phone_number" : "5558531970",
      "email_address" : "crogers.demo@squareup.com",
      "team" : "Public Web & Marketing",
      "employee_type" : "PART_TIME"
    }
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    
    let image = await viewModel.loadImage(imageLoader: MockImageLoader(shouldSucceed: true))
    // We expect image to be nil because there's no URL
    XCTAssertNil(image)
  }
  
  func testLoadImageBadUrl() async throws {
    let employeeJsonData = Data("""
    {
      "uuid" : "a98f8a2e-c975-4ba3-8b35-01f719e7de2d",

      "full_name" : "Camille Rogers",
      "phone_number" : "5558531970",
      "email_address" : "crogers.demo@squareup.com",
      "biography" : "Designer on the web marketing team.",

      "photo_url_small" : "garbage data",
      "photo_url_large" : "garbage data",

      "team" : "Public Web & Marketing",
      "employee_type" : "PART_TIME"
    }
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    
    let image = await viewModel.loadImage(imageLoader: MockImageLoader(shouldSucceed: true))
    
    // We expect image to be nil because the URL is invalid
    XCTAssertNil(image)
  }
  
  func testLoadImageFail() async throws {
    let employeeJsonData = Data("""
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
    """.utf8)
    
    let employee = try JSONDecoder().decode(Employee.self, from: employeeJsonData)
    
    let viewModel = EmployeeTableViewCellViewModel(employee: employee)
    
    let image = await viewModel.loadImage(imageLoader: MockImageLoader(shouldSucceed: false))
    
    // We expect image to be nil because the load failed
    XCTAssertNil(image)
  }
}
