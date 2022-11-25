//
//  CreatePostViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/24/22.
//

import UIKit
import Firebase
import FirebaseStorage

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postPressed(_ sender: UIButton) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Get the inputted name
        guard let postText = self.postTextView.text, postTextView.text.isEmpty == false else {
            return
        }
        
        let reference = Database.database().reference()
        
        //let storage = Storage.storage().reference(forURL: "")
        
        let post = reference.child("posts").childByAutoId()

        // Create the user dictionary info
        var dataArray: [String: Any] = [
            "username": "User",
            "pathToImage": "http://www.fdfdf.jpg",
            "postText": postText,
            "userID": userId,
            "postID": post.key
        ]
        
        post.setValue(dataArray)
        //reference.child("posts").updateChildValues(dataArray)
        
        self.dismiss(animated: true, completion: nil)
        /*
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
        */
    }
}
