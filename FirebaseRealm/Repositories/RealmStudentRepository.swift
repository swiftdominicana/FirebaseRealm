//
//  AppDelegate.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 13/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmStudentRepository: Repository {
  typealias EntityObject = Student
  let realm = try! Realm()
  
  func getFirst(id: Any, completion:@escaping (_ snapshot: Student?) -> Void) {
    let student = findStudent(key: id)
    completion(student)
  }
  
  private func findStudent(key: Any) -> Student? {
    guard let key = key as? String else {
      return nil
    }
    
    let students = realm.objects(EntityObject.self).filter("key = '\(key)'")
    if(students.count > 0) {
      return students.first
    }
    
    return nil
  }
  
  func add(object: EntityObject) -> String? {
    let key = UUID().uuidString
    object.key = key
    
    try! realm.write {
      realm.add(object)
    }
    
    return key
  }
  func remove(object: EntityObject, key: Any) {
    if let student = findStudent(key: key) {
      try! realm.write {
        realm.delete(student)
      }
    }
  }
  
  func update(object: EntityObject, key: Any) {
    guard let key = key as? String else {
      return
    }
    
    try! realm.write {
      object.key = key
      realm.add(object, update: .modified)
    }
  }
}
