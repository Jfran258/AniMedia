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
    
    @IBOutlet weak var App_Name: UILabel!
    
    @IBOutlet weak var Register_Button: UIButton!
    
    @IBOutlet weak var Spark_Message: UILabel!
    
    override func viewDidLoad() {
        registeremail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        registeremail.layer.cornerRadius = 15
        registeremail.borderStyle = .none
        
        passwordemail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        passwordemail.layer.cornerRadius = 15
        passwordemail.borderStyle = .none
        
        username.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        username.layer.cornerRadius = 15
        username.borderStyle = .none
        
        Register_Button.layer.cornerRadius = 15
        
        
        let App_N = "AniMedia"
        let attributeText = NSMutableAttributedString(string: App_N)
        attributeText.addAttribute(.foregroundColor, value: UIColor.systemCyan, range: NSRange(location: 3, length: 5))
        App_Name.attributedText = attributeText
        
        
        let Spark_M = "SparkDev iOS Fall 2022"
        let attribute_M = NSMutableAttributedString(string: Spark_M)
        attribute_M.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: 8))
        Spark_Message.attributedText = attribute_M
        
    }
    
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
