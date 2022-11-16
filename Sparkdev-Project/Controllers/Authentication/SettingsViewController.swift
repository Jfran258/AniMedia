//
//  SettingsViewController.swift
//  Sparkdev-Project
//
//  Created by Julian Arias on 11/11/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var usernameSettings: UITextField!
    
    @IBOutlet weak var bioSettings: UITextField!
    
    private let database = Database.database().reference()
    
    var BioU: Room?
    
    public var completionHandlerProfile: ((String?) -> Void)?
    public var completionHandlerBio: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var refUser: DatabaseReference!
        refUser = Database.database().reference()
        
        
        
        
        
        
        database.child("username").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
        })
        usernameSettings.layer.cornerRadius = 22
        bioSettings.layer.cornerRadius = 22
        /*
         guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
         let url = URL(string: urlString) else {
         return
         }
         let task = URLSession.shared.dataTask(with: url, completionHandler: { data,_, error in
         guard let data = data, error == nil else {
         return
         }
         DispatchQueue.main.async {
         let image = UIImage(data: data)
         self.backImage.image = image
         }
         
         })
         task.resume()
         */
        // Do any additional setup after loading the view.
    }
    /*
        func UpdateInfo() {
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }
            let refUser = Database.database().reference()
            
            let user = refUser.child("users").child(userId)
            
            user.child("username").observeSingleEvent(of: .value) { (snapshot) in
                if let userName = snapshot.value as? String {
                    if let BioId = self.Bio?.roomId, let userId = Auth.auth().currentUser?.uid {
                        let Bio = databaseRef.child("Bio").child(BioId)
                    })
                }
            }
            */
            @IBAction func didTapSave(_ sender: Any) {
                completionHandlerProfile?(usernameSettings.text)
                completionHandlerBio?(bioSettings.text)
                //SaveInfo()
                
                //dismiss(animated: true, completion: nil)
            }
            /*
             func UpdateInfo(Bio: String) {
             let user = [
             "Bio": Bio
             ]
             
             }
             */
            /*
             func SaveInfo() {
             guard let userId = Auth.auth().currentUser?.uid else {
             return
             }
             let user = database.child("users").child(userId)
             
             let object: [String: Any] = [
             "Bio": bioSettings.text]
             database.child(userId).setValue(object)
             
             
             }
             */
            /*
             @IBAction func pictureProfile(_ sender: Any) {
             let picker = UIImagePickerController()
             picker.sourceType = .photoLibrary
             picker.delegate = self
             picker.allowsEditing = true
             present(picker, animated: true)
             }
             
             
             func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
             return
             }
             guard let imageData = image.pngData() else {
             return
             }
             
             
             storage.child("images/file.png").putData(imageData, metadata: nil, completion: {_, error in
             guard error == nil else {
             print("Failed to Upload")
             return
             }
             self.storage.child("images/file.png").downloadURL(completion: {url, error in
             guard let url = url, error == nil else {
             return
             }
             let urlString = url.absoluteString
             print("Download URL: \(urlString)")
             UserDefaults.standard.set(urlString, forKey: "url")
             })
             })
             }
             
             
             func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             picker.dismiss(animated: true, completion: nil)
             }
             */
            
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
            
        }
