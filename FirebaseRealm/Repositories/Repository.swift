//
//  AppDelegate.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 13/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

protocol Repository {
  associatedtype EntityObject: RemoteEntity
  
  func getFirst(id: Any, completion:@escaping (_ snapshot: EntityObject?) -> Void)
  func add(object: EntityObject) -> String?
  func remove(object: EntityObject, key: Any)
  func update(object: EntityObject, key: Any)
}

protocol RemoteEntity {
  func getId() -> Any?
}
