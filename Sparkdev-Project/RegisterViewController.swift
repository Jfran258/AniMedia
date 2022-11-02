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
    
    @IBOutlet var parentView: UIView!
    //@IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var Spark_Message: UILabel!
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor(red: 31/255, green: 35/255, blue: 41/255, alpha: 1)
        
        registeremail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        registeremail.layer.cornerRadius = 22
        registeremail.borderStyle = .none
        
        passwordemail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        passwordemail.layer.cornerRadius = 22
        passwordemail.borderStyle = .none
        
        username.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        username.layer.cornerRadius = 22
        username.borderStyle = .none
        
        Register_Button.layer.cornerRadius = 17
        
        
        let App_N = "AniMedia"
        let attributeText = NSMutableAttributedString(string: App_N)
        attributeText.addAttribute(.foregroundColor, value: UIColor.systemCyan, range: NSRange(location: 3, length: 5))
        App_Name.attributedText = attributeText
        
        
        
        
        /*
        let attribute_M = NSMutableAttributedString(string: Spark_M)
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.blue.cgColor, UIColor.orange.cgColor]
        attribute_M.addAttribute(.foregroundColor, value: newLayer, range: NSRange(location: 0, length: 8))
        //attribute_M.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: 8))
        Spark_Message.attributedText = attribute_M
        
        */
        
    }
    
    @IBAction func Register(_ sender: UIButton) {
            if let email = registeremail.text, let password =  passwordemail.text {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e.localizedDescription)
                        self.showError()
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
                        //self.performSegue(withIdentifier: "RegisterTab", sender: self)
                        self.checkUserInfo()
                           // let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           // let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                           // vc.modalPresentationStyle = .overFullScreen
                           // self.present(vc, animated: true)
                        
                    }
                }
            }
        }
    
    func showAlert(title: String, messege: String) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError() {
        let email = isEmailValid(testStr: registeremail.text!)
        let password = isPasswordValid(testStr: passwordemail.text!)
        if email == false {
            showAlert(title: "ERROR!", messege: "This is not a valid email. Please Try Again")
            registeremail.text = ""
        }
        else if password == false {
            showAlert(title: "ERROR!", messege: "This is not a valid password. Please Try Again")
            passwordemail.text = ""
        }
    
    }
     func isPasswordValid(testStr: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func isEmailValid(testStr: String) -> Bool {
       // let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let test = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        //let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return test.evaluate(with: testStr)
        //"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}
        
    }
    func checkUserInfo() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Home")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        
    }
}
