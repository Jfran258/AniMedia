//
//  SettingsViewController.swift
//  Sparkdev-Project
//
//  Created by Julian Arias on 11/18/22.
//

import UIKit
import Firebase
import FirebaseStorage
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameSetting: UITextField!
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var backImage: UIImageView!
    
    
    @IBOutlet weak var bioSetting: UITextField!
    public var completionHandlerProfile: ((String?) -> Void)?
    public var completionHandlerBio: ((String?) -> Void)?
    public var completionHandlerPicture: ((String?) -> Void)?
    public var completionHandlerBackPicture: ((String?) -> Void)?
    
    var imagePicker: UIImagePickerController!
 
    
    let storage = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveButton.layer.cornerRadius = 17
        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
                    profileImage.isUserInteractionEnabled = true
                    profileImage.addGestureRecognizer(imageTap)
                    profileImage.layer.cornerRadius = profileImage.bounds.height / 2
                    profileImage.clipsToBounds = true
                    //taptochange.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        let imageTap2 = UITapGestureRecognizer(target: self, action: #selector(openImagePicker2))
        
                    backImage.isUserInteractionEnabled = true
                    backImage.addGestureRecognizer(imageTap2)
                    backImage.clipsToBounds = true
                    
                    imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    
        getUserData()
        
        
 
    }
    func getUserData() {
        // Do any additional setup after loading the view.
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Reference to database
        let databaseRef = Database.database().reference()
  
        // Reference to current user
        let userRef = databaseRef.child("users").child(userId)
  
        // Accessing information for that user
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Create User object
            let aUser = User(withSnapShot: snapshot)
            //print(aUser)

            //print(aUser.userName)
            //print(aUser.bio)
            print(aUser.profileUrl)
            print(aUser.uid)
            
            let newUrl = URL(string: aUser.profileUrl)
            let newUrl2 = URL(string: aUser.backPImageUrl)
            
           // self.usernameLabel.text = aUser.userName
            self.profileImage.af.setImage(withURL: newUrl!)
            self.backImage.af.setImage(withURL: newUrl2!)
            //self.bioLabel.text = aUser.bio
        }
        
        
    }
    
    @objc func openImagePicker(_ sender:Any) {
            //Opens Image Picker
            self.present(imagePicker, animated: true, completion: nil)
        }
    
    @objc func openImagePicker2(_ sender:Any) {
            //Opens Image Picker
            self.present(imagePicker, animated: true, completion: nil)
        }
   


    @IBAction func didTapSave(_ sender: Any) {
        if (usernameSetting.text != "") {
            completionHandlerProfile?(usernameSetting.text)
        }
        if (usernameSetting.text != "") {
            completionHandlerBio?(bioSetting.text)
        }
        
        //dismiss(animated: true, completion: nil)
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to current user
        let userRef = databaseRef.child("users").child(userId)
        
        //let US = completionHandlerProfile?(usernameSetting.text)
        if (usernameSetting.text != "" || bioSetting.text != "") {
            userRef.updateChildValues([
                "username": usernameSetting.text!,
                "bio": bioSetting.text!
            ])
        }
        _ = UIStoryboard(name: "Main", bundle: nil)
        
        navigationController?.popViewController(animated: true)
        
    }
}

struct User {
    var userName: String
    var bio: String
    var uid: String
    var profileUrl: String
    var backPImageUrl: String
    
    init(withSnapShot: DataSnapshot) {
        let dict = withSnapShot.value as! [String: AnyObject]
        
        uid = withSnapShot.key
        userName = dict["username"] as! String
        bio = dict["bio"] as! String
        profileUrl = dict["profileImageUrl"] as! String
        backPImageUrl = dict["BackImageURL"] as! String
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        
        func imagePickerController(_ pickerBack: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedBackImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                guard let jpegBackData = pickedBackImage.pngData() else {
                    return
                }
                guard let userId = Auth.auth().currentUser?.uid else {
                    return
                }
                storage.child("\(userId)/backImage.png").child("back.png").putData(jpegBackData, metadata: nil, completion: {_, error in
                    guard error == nil else {
                        print("Failed to upload")
                        return
                    }
                    
                    self.storage.child("\(userId)/backImage.png").child("back.png").downloadURL(completion: {url, error in
                        guard let url2 = url, error == nil else {
                            return
                        }
                        let urlString2 = url2.absoluteString
                        print("Download BackURL:  \(urlString2)")
                        
                        self.completionHandlerBackPicture?(urlString2)
                        // Reference to database
                        let databaseRef = Database.database().reference()
                        
                        // Reference to current user
                        let userRef = databaseRef.child("users").child(userId)
                        
                        //let US = completionHandlerProfile?(usernameSetting.text)
                        userRef.updateChildValues([
                            "BackImageURL": urlString2
                        ])
                    })
                })
                self.backImage.image = pickedBackImage
                
            }
            pickerBack.dismiss(animated: true, completion: nil)
            
        }
    }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                
                if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    guard let jpegData = pickedImage.pngData() else {
                        return
                    }
                    
                    guard let userId = Auth.auth().currentUser?.uid else {
                        return
                    }
                    storage.child("\(userId)/profileImage.png").child("profileImage.png").putData(jpegData, metadata: nil, completion: {_, error in
                        guard error == nil else {
                            print("Failed to upload")
                            return
                        }
                        
                        self.storage.child("\(userId)/profileImage.png").child("profileImage.png").downloadURL(completion: {url, error in
                            guard let url = url, error == nil else {
                                return
                            }
                            let urlString = url.absoluteString
                            print("Download URL:  \(urlString)")
                            
                            self.completionHandlerPicture?(urlString)
                            // Reference to database
                            let databaseRef = Database.database().reference()
                            
                            // Reference to current user
                            let userRef = databaseRef.child("users").child(userId)
                            
                            //let US = completionHandlerProfile?(usernameSetting.text)
                            userRef.updateChildValues([
                                "profileImageUrl": urlString
                            ])
                        })
                    })
                    self.profileImage.image = pickedImage
                }
                
                
                picker.dismiss(animated: true, completion: nil)
            }
        }
        
    
    

