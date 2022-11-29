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
import FirebaseStorage

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
                    
                    // Create the user dictionary info
                    var dataArray: [String: Any] = [
                        "username": userName,
                        "profileImageUrl": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHoAAAB6CAMAAABHh7fWAAAAKlBMVEXY4uP////5+vvo7u7e5ufb5eXw9PTs8fHk6+z1+Pjh6en7/f3V4eHn7O4uLtgkAAACOElEQVRoge2ay5qDIAxGRVAuOu//uiO2Tq03Ev2ji8lZdnO+SBIgtKoURVEURRGldylY+xNSavo7vU1qazNR1226Tdx2ZkHnmzvM7dL7opX29nZbnAmii97EfbMxUdK8WuTFkoutuDsWZ5yQuRDzGLeMuy6bhyqXMB9m2IeIz/ODqvrGos0N1WwMWr3Tw7YA9zVG0OiwPUftoWpCSX/okObEMWN7Gut7YxON2E4mgFsYK78zuB2MsGVJqZlZZgzunEju3xO4Pq5qEgGmfjDNHqzrB9UPNlLOGSWD3LAf3DQfPCo8eUCqOGqsmRM2OGhG2NiVzpD7OK5//0GsbZGZCumSKzPUKI0zMlIjjfJYQW6YUmpqIiOFicNcE57ahd3AO4Gq+qbZCRzewzboG78ez9pbxrOZ5GdFHn26dSTeVy7YgXBbuIpyF0MpuRCsH7EhuPEncVzw6wefoae0Pkg+eDUhHm5dnZepcmePvW97tA789RP9wte1yHuPJR3LPkTUQMOyLlzv0AHyo+e8Y/nVxz7HvNTPiZfWnDkRXmJPB34l5HfgJ+ucPbLaoDs1xgoAszn1tHw2s1ewF/xigl1ww2Ie3RwzaJ0nGPcS9oNDCXJz6S/X8xLyhR+YYhPU5cabqbM0+OfOkO7e8Bx7Qck05gCaCiFsoaApLwPQPjbnp6gWSbJMsbbFvnf5jzrg7j2ndGoQ6GQTpY4mVFqZUnmJZVk5z5hXHA6lCaqqVa1qVata1apW9b9X/wL3wB5NTABXpQAAAABJRU5ErkJggg==",
                        "uid": userId,
                        "bio": "I am new here.",
                        "BackImageURL": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHoAAAB6CAMAAABHh7fWAAAAKlBMVEXY4uP////5+vvo7u7e5ufb5eXw9PTs8fHk6+z1+Pjh6en7/f3V4eHn7O4uLtgkAAACOElEQVRoge2ay5qDIAxGRVAuOu//uiO2Tq03Ev2ji8lZdnO+SBIgtKoURVEURRGldylY+xNSavo7vU1qazNR1226Tdx2ZkHnmzvM7dL7opX29nZbnAmii97EfbMxUdK8WuTFkoutuDsWZ5yQuRDzGLeMuy6bhyqXMB9m2IeIz/ODqvrGos0N1WwMWr3Tw7YA9zVG0OiwPUftoWpCSX/okObEMWN7Gut7YxON2E4mgFsYK78zuB2MsGVJqZlZZgzunEju3xO4Pq5qEgGmfjDNHqzrB9UPNlLOGSWD3LAf3DQfPCo8eUCqOGqsmRM2OGhG2NiVzpD7OK5//0GsbZGZCumSKzPUKI0zMlIjjfJYQW6YUmpqIiOFicNcE57ahd3AO4Gq+qbZCRzewzboG78ez9pbxrOZ5GdFHn26dSTeVy7YgXBbuIpyF0MpuRCsH7EhuPEncVzw6wefoae0Pkg+eDUhHm5dnZepcmePvW97tA789RP9wte1yHuPJR3LPkTUQMOyLlzv0AHyo+e8Y/nVxz7HvNTPiZfWnDkRXmJPB34l5HfgJ+ucPbLaoDs1xgoAszn1tHw2s1ewF/xigl1ww2Ie3RwzaJ0nGPcS9oNDCXJz6S/X8xLyhR+YYhPU5cabqbM0+OfOkO7e8Bx7Qck05gCaCiFsoaApLwPQPjbnp6gWSbJMsbbFvnf5jzrg7j2ndGoQ6GQTpY4mVFqZUnmJZVk5z5hXHA6lCaqqVa1qVata1apW9b9X/wL3wB5NTABXpQAAAABJRU5ErkJggg=="
                    ]
                    
                    // Reference to Storage
                    let storageRef = Storage.storage().reference(forURL: "gs://animedia-7ff8a.appspot.com")

                    // Reference to Profile child
                    let storageProfileRef = storageRef.child("profile").child(userId)
                    
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpg"
                    
                    let image = UIImage(named: "defaultprofile")
                    
                    guard let imageData = image?.jpegData(compressionQuality: 0.4) else {
                        return
                    }
                    
                    // Saving image data to Storage
                    storageProfileRef.putData(imageData, metadata: metaData) { (StorageMetadata, error) in
                        if error != nil {
                            print(error?.localizedDescription)
                            return
                        }
                        
                        // Getting image url from Storage
                        storageProfileRef.downloadURL { (url, error) in
                            if let metaImageUrl = url?.absoluteString {
                                // Updating dict with retrieved image url
                                dataArray["profileImageUrl"] = metaImageUrl
                                
                                // Save user info to database
                                user.setValue(dataArray)
                                
                                //Navigate to View Controller
                                self.checkUserInfo()
                            }
                        }
                    }
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
