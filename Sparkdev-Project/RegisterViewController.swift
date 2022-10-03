//
//  RegisterViewController.swift
//  Sparkdev-Project
//
//  Created by Jason Francis on 9/30/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registeremail: UITextField!
    
    @IBOutlet weak var passwordemail: UITextField!
    
    @IBAction func Register(_ sender: UIButton) {
        
        if let email = registeremail.text, let password =  passwordemail.text {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e.localizedDescription)
                
                
                
            } else {
                //Navigate to View Controller
                self.performSegue(withIdentifier: "RegisterTab", sender: self)
            }
          
        }
        
        }
    }
    
}
