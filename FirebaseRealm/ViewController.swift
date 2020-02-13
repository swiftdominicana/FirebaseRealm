//
//  ViewController.swift
//  FirebaseRealm
//
//  Created by Libranner Leonel Santos Espinal on 13/02/2020.
//  Copyright © 2020 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var lastnameTextField: UITextField!
  @IBOutlet var ageTextField: UITextField!
  
  @IBOutlet var saveButton: UIButton!
  @IBOutlet var updateButton: UIButton!
  
  @IBOutlet var removeButton: UIButton!
  private let DATA_KEY = "DATA_KEY"
  private let repository = FirebaseStudentRepository()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    loadStudent()
  }
  
  private func getStudent() -> Student? {
    guard let name = nameTextField.text else {
      return nil
    }
    
    guard let lastname = lastnameTextField.text else {
      return nil
    }
    
    guard
      let rawAge = ageTextField.text,
      let age = Int(rawAge) else {
      return nil
    }
    
    return Student(name: name, lastname: lastname, age: age)
  }
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    addStudent()
  }
  
  @IBAction func updateStudent(_ sender: Any) {
    guard let key = UserDefaults.standard.value(forKey: DATA_KEY) else {
      return
    }
    
    if let student = getStudent() {
      repository.update(object: student, key: key)
    }
  }
  
  @IBAction func removeButtonTapped(_ sender: Any) {
    removeStudent()
  }
  
  private func addStudent() {
    guard let student = getStudent() else {
      return
    }
    
    if let key = repository.add(object: student) {
      UserDefaults.standard.set(key, forKey: DATA_KEY)
      saveButton.isHidden = true
      updateButton.isHidden = false
      removeButton.isHidden = false
    }
  }
  
  private func removeStudent() {
    guard let key = UserDefaults.standard.value(forKey: DATA_KEY) else {
      return
    }
    
    if let student = getStudent() {
      repository.remove(object: student, key: key)
      UserDefaults.standard.set(nil, forKey: DATA_KEY)
      saveButton.isHidden = false
      updateButton.isHidden = true
      removeButton.isHidden = true
      nameTextField.text = ""
      lastnameTextField.text = ""
      ageTextField.text = ""
    }
  }
  
  private func loadStudent() {
    guard let key = UserDefaults.standard.value(forKey: DATA_KEY) else {
      saveButton.isHidden = false
      updateButton.isHidden = true
      removeButton.isHidden = true
      return
    }
    
    repository.getFirst(id: key) { [weak self] (student) in
      if let student = student {
        self?.nameTextField.text = student.name
        self?.lastnameTextField.text = student.lastname
        self?.ageTextField.text = String(student.age)
        self?.saveButton.isHidden = true
        self?.updateButton.isHidden = false
        self?.removeButton.isHidden = false
      }
    }
  }
}


