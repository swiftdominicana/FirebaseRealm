//
//  AppDelegate.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 13/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object, RemoteEntity {
  @objc dynamic var name = ""
  @objc dynamic var lastname = ""
  @objc dynamic var age = 0
  @objc dynamic var key: String = ""
  
  convenience init(name: String, lastname: String, age: Int) {
    self.init()
    self.name = name
    self.lastname = lastname
    self.age = age
  }
  
  func getId() -> Any? {
    return key
  }
  
  override class func primaryKey() -> String? {
    "key"
  }
  
  func encode() -> [String: Any] {
    return [
      "name": name,
      "lastname": lastname,
      "age" :age
    ]
  }
  
  static func decode(dict: [String: Any]) -> Student {
    return Student(
      name: dict["name"] as! String,
      lastname: dict["lastname"] as! String,
      age: dict["age"] as! Int
    )
  }
}
