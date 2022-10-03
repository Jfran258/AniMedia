//
//  LoginViewController.swift
//  Sparkdev-Project
//
//  Created by Jason Francis on 9/30/22.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginemail: UITextField!
    
    @IBOutlet weak var passwordlogin: UITextField!
    
    @IBAction func Login(_ sender: UIButton) {
        
        if let email = loginemail.text, let password = passwordlogin.text {
        
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
          
          // ...
            if let e = error {
                print(e)
            } else {
                self.performSegue(withIdentifier: "LoginTab", sender: self)
                
            }
         }
      }
        
        
    }
    
}
