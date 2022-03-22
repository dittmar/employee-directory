//
//  CoreDataHelper.swift
//  Employee Directory
//
//  Created by Kevin Dittmar on 3/22/22.
//

import EmployeeDirectoryApi
import CoreData
import Foundation

final class CoreDataHelper {
  static let shared = CoreDataHelper()
  
  let container: NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "EmployeeDirectory")
    
    container.loadPersistentStores { _, error in
      if let error = error {
        // TODO (dittmar): report error?
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchEmployees() throws -> [Employee] {
    let request = NSFetchRequest<NSManagedObject>(entityName: "CachedEmployee")
    
    let results: [NSManagedObject] = try container.viewContext.fetch(request)
    
    return results.compactMap { cachedEmployee -> Employee? in
      guard let uuid = cachedEmployee.value(forKey: "uuid") as? String,
            let fullName = cachedEmployee.value(forKey: "fullName") as? String,
            let emailAddress = cachedEmployee.value(forKey: "emailAddress") as? String,
            let teamString = cachedEmployee.value(forKey: "team") as? String,
            let team = Employee.Team(rawValue: teamString),
            let employeeTypeString = cachedEmployee.value(forKey: "employeeType") as? String,
            let employeeType = Employee.EmploymentType(rawValue: employeeTypeString) else {
        return nil
      }
      
      let phoneNumber = cachedEmployee.value(forKey: "phoneNumber") as? String
      let biography = cachedEmployee.value(forKey: "biography") as? String
      let smallPhotoUrlString = cachedEmployee.value(forKey: "smallPhotoUrlString") as? String
      let largePhotoUrlString = cachedEmployee.value(forKey: "largePhotoUrlString") as? String
      
      
      return Employee(uuid: uuid,
                      fullName: fullName,
                      phoneNumber: phoneNumber,
                      emailAddress: emailAddress,
                      biography: biography,
                      smallPhotoUrlString: smallPhotoUrlString,
                      largePhotoUrlString: largePhotoUrlString,
                      team: team,
                      employeeType: employeeType)
    }
  }
}

extension Employee {
  func save() throws {
    let context = CoreDataHelper.shared.container.viewContext
    
    guard let entityDescription = NSEntityDescription.entity(forEntityName: "CachedEmployee", in: context) else {
      // TODO (dittmar): handle error
      fatalError()
    }
    
    let managedObject = NSManagedObject(entity: entityDescription, insertInto: context)
    
    managedObject.setValue(uuid, forKey: "uuid")
    managedObject.setValue(fullName, forKey: "fullName")
    managedObject.setValue(phoneNumber, forKey: "phoneNumber")
    managedObject.setValue(emailAddress, forKey: "emailAddress")
    managedObject.setValue(biography, forKey: "biography")
    managedObject.setValue(smallPhotoUrlString, forKey: "smallPhotoUrlString")
    managedObject.setValue(largePhotoUrlString, forKey: "largePhotoUrlString")
    managedObject.setValue(team.rawValue, forKey: "team")
    managedObject.setValue(employeeType.rawValue, forKey: "employeeType")
    
    try context.save()
  }
}
