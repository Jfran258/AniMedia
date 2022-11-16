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
    
    @IBOutlet weak var App_Name: UILabel!
    @IBOutlet weak var Register_Button: UIButton!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var registeremail: UITextField!
    
    @IBOutlet weak var passwordemail: UITextField!
    
   
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor(red: 31/255, green: 35/255, blue: 41/255, alpha: 1)
        
        registeremail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        registeremail.layer.cornerRadius = 22
        registeremail.borderStyle = .none
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        registeremail.leftView = paddingView
        registeremail.leftViewMode = .always
        
        passwordemail.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        passwordemail.layer.cornerRadius = 22
        passwordemail.borderStyle = .none
        passwordemail.textContentType = .oneTimeCode
        
        let paddingViews: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        passwordemail.leftView = paddingViews
        passwordemail.leftViewMode = .always
        
        username.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        username.layer.cornerRadius = 22
        username.borderStyle = .none
        
        let paddingViewss: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        username.leftView = paddingViewss
        username.leftViewMode = .always
        
        Register_Button.layer.cornerRadius = 17
        
        
        let App_N = "AniMedia"
        let attributeText = NSMutableAttributedString(string: App_N)
        attributeText.addAttribute(.foregroundColor, value: UIColor.systemCyan, range: NSRange(location: 3, length: 5))
        App_Name.attributedText = attributeText
        
        
    }

    @IBAction func ReturnLogin(_ sender: Any) {
        _ = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "Login")
        navigationController?.popViewController(animated: true)
        /*
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
         */
    }
    
    @IBAction func Register(_ sender: Any) {
        if let email = registeremail.text, let password =  passwordemail.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    if (self.username.text == "" || email == "" || password == "") {
                        self.showAlert(title: "ERROR!", messege: "Please fill out the empty fields")
                    } else {
                        self.showAlert(title: "ERROR!", messege: e.localizedDescription)
                    }
                    //self.showError()
                } else {
                    guard let userId = authResult?.user.uid, let userName = self.username.text else {
                        return
                    }
                    print("User: \(userId)")
                    
                    let reference = Database.database().reference()
                    let user = reference.child("users").child(userId)
                    
                    let dataArray:[String: Any] = ["username": userName, "profileImageUrl":"", "Bio": ""]
                    
                    user.setValue(dataArray)
                    
                    self.checkUserInfo()
                    
                }
            }
        }
    }
    func showAlert(title: String, messege: String) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
 
    func checkUserInfo() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Home")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        
    }
}

   
    

