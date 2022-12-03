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
   
    @IBOutlet weak var App_Name: UILabel!
    @IBOutlet weak var Password_Input: UITextField!
    @IBOutlet weak var Email_Input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                 view.addGestureRecognizer(tapGesture)

        
        view.backgroundColor = UIColor(red: 31/255, green: 35/255, blue: 41/255, alpha: 1)
        
        Email_Input.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        Email_Input.borderStyle = .none
        Email_Input.layer.cornerRadius = 22
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        Email_Input.leftView = paddingView
        Email_Input.leftViewMode = .always
        
        Password_Input.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        Password_Input.borderStyle = .none
        Password_Input.layer.cornerRadius = 22
        
        let paddingViews: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        Password_Input.leftView = paddingViews
        Password_Input.leftViewMode = .always
        
        
        Login_Button.layer.cornerRadius = 17
        
        
        let App_N = "AniMedia"
        let attributeText = NSMutableAttributedString(string: App_N)
        attributeText.addAttribute(.foregroundColor, value: UIColor(red: 28.0/255, green: 181.0/255, blue: 224.0/255, alpha: 1), range: NSRange(location: 3, length: 5))
        App_Name.attributedText = attributeText
        
        
        
        
        navigationItem.backButtonTitle = ""
        
        
    }
    
    func checkUserInfo() {
        if Auth.auth().currentUser != nil {
            //print(Auth.auth().currentUser?.uid)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Home")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    @IBAction func Sign_Up(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Register")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Login(_ sender: Any) {
        if let email = Email_Input.text, let password = Password_Input.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                
                // ...
                if email == "" || password == "" {
                    self.showAlert(title: "ERROR!", messege: "Please fill out the empty fields")
                }
                else if error != nil {
                    //print(e)
                    self.showAlert(title: "ERROR!", messege: "Login or Password is invalid")
                } else {
                    self.checkUserInfo()
                    //self.performSegue(withIdentifier: "LoginTab", sender: self)
                }
            }
        }
    }
   
    func showAlert(title: String, messege: String) {
        let alert = UIAlertController(title: title, message: messege, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
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

