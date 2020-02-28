//
//  CoreDataStudentRepository.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 28/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStudentRepository: Repository {
  typealias EntityObject = Student
  
  func getFirst(id: Any, completion:@escaping (_
    snapshot: EntityObject?) -> Void) {
    
    guard let studentId = id as? String else {
      completion(nil)
      return
    }
    
    getRecord(id: studentId) { studentCD in
      completion(studentCD?.mapFromCoreData())
    }
  }
  
  func add(object: EntityObject) -> String? {
    let student = StudentCD(context: context)
    student.name = object.name
    student.lastname = object.lastname
    student.age = Int32(object.age)
    student.studentId = UUID().uuidString
    
    context.perform { [weak self] in
      do {
        try self?.context.save()
      }
      catch {
        print("Unexpected error")
      }
    }
    
    return student.studentId
  }
  
  func remove(object: EntityObject, key: Any) {
    guard let studentId = key as? String else {
      return
    }
    
    getRecord(id: studentId) { [weak self] studentCD in
      if let studentCD = studentCD {
        self?.context.delete(studentCD)
        do {
          try self?.context.save()
        }
        catch {
          print("Unexpected error. Removing Record")
        }
      }
    }
  }
  
  func update(object: EntityObject, key: Any) {
    guard let studentId = key as? String else {
      return
    }
    
    getRecord(id: studentId) { [weak self] student in
      guard let student = student else {
        return
      }
      student.name = object.name
       student.age = Int32(object.age)
      
      self?.context.perform { [weak self] in
        do {
          try self?.context.save()
        }
        catch {
          print("Unexpected error. Fetching record")
        }
      }
    }
  }
  
  private var context: NSManagedObjectContext {
    return self.persistentContainer.viewContext
  }
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Database")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private func getRecord(id: String, completion:@escaping (_
    studentCD: StudentCD?) -> Void) {
    
    let fetchRequest: NSFetchRequest<StudentCD> = StudentCD.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "studentId = %@", id)
    
    if let results = try? context.fetch(fetchRequest),
      let student = results.first {
      
      completion(student)
      return
    }
    
    completion(nil)
  }
}


extension StudentCD: RemoteEntity {
  func getId() -> Any? {
    return self.studentId
  }
  
  func mapFromCoreData() -> Student {
    let student = Student(name: self.name ?? "",
                          lastname: self.lastname ?? "",
                          age: Int(self.age))
    student.key = self.studentId ?? ""
    return student
  }
}
