//
//  LoginsViewController.swift
//  Sparkdev-Project
//
//  Created by Julian Arias on 10/17/22.
//

import UIKit
import Foundation
import FirebaseAuth
import SwiftUI


class LoginsViewController: UIViewController {

    @IBOutlet weak var Login_Button: UIButton!
    @IBOutlet weak var Spark_Messege: UILabel!
    @IBOutlet weak var App_Name: UILabel!
    @IBOutlet weak var Password_Input: UITextField!
    @IBOutlet weak var Email_Input: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 31/255, green: 35/255, blue: 41/255, alpha: 1)
        
        Email_Input.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        Email_Input.borderStyle = .none
        Email_Input.layer.cornerRadius = 22
        
        Password_Input.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        Password_Input.borderStyle = .none
        Password_Input.layer.cornerRadius = 22
        
        Login_Button.layer.cornerRadius = 17
        
        
        let App_N = "AniMedia"
        let attributeText = NSMutableAttributedString(string: App_N)
        attributeText.addAttribute(.foregroundColor, value: UIColor.systemCyan, range: NSRange(location: 3, length: 5))
        App_Name.attributedText = attributeText
        
        
        let Spark_M = "SparkDev iOS Fall 2022"
        let attribute_M = NSMutableAttributedString(string: Spark_M)
        attribute_M.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: 8))
        Spark_Messege.attributedText = attribute_M
        
        
    }
    
    @IBAction func Login(_ sender: UIButton) {
        if let email = Email_Input.text, let password = Password_Input.text {
            
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
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

