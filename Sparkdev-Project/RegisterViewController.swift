//
//  RegisterViewController.swift
//  Sparkdev-Project
//
//  Created by Jason Francis on 9/30/22.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var registeremail: UITextField!
    
    @IBOutlet weak var passwordemail: UITextField!
    
    @IBAction func Register(_ sender: UIButton) {
        
        if let email = registeremail.text, let password =  passwordemail.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    guard let userId = authResult?.user.uid, let userName = self.username.text else {
                        return
                    }
                    print("User: \(userId)")
                    
                    let reference = Database.database().reference()
                    let user = reference.child("users").child(userId)
                    
                    let dataArray:[String: Any] = ["username": userName]
                    
                    user.setValue(dataArray)
                    //Navigate to View Controller
                    self.performSegue(withIdentifier: "RegisterTab", sender: self)
                }
            }
        }
    }
}
