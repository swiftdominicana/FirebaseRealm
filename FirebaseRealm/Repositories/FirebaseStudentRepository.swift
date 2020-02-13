//
//  AppDelegate.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 13/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseStudentRepository: Repository {
  typealias EntityObject = Student
  private let path = "students"
  private var ref = Database.database().reference()
  
  func getFirst(id: Any, completion:@escaping (_ snapshot: Student?) -> Void) {
    guard let key = id as? String else {
      completion(nil)
      return
    }
    
    let studentRef = ref.child(path).child(key)
    
    studentRef.observe(DataEventType.value, with: { (snapshot) in
      
      if let postDict = snapshot.value as? [String : AnyObject] {
        let student = EntityObject.decode(dict: postDict)
        student.key = snapshot.key
        completion(student)
      }
    })
  }
  
  func add(object: EntityObject) -> String? {
    guard let key = ref.child(path).childByAutoId().key else { return nil }

    ref.child(path).child(key).setValue(object.encode())
    return key
  }
  
  func remove(object: EntityObject, key: Any) {
    guard let key = key as? String else {
      return
    }
    
    ref.child(path).child(key).removeValue()
  }
  
  func update(object: EntityObject, key: Any) {
    guard let key = key as? String else {
      return
    }
    
    ref.child(path).child(key).setValue(object.encode()) {
      (error:Error?, ref:DatabaseReference) in
      if let error = error {
        print("Data could not be saved: \(error).")
      } else {
        print("Data saved successfully!")
      }
    }
  }
}
