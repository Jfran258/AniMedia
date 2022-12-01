//
//  CreatePostViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/24/22.
//

import UIKit
import Firebase
import FirebaseStorage

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        postTextView.becomeFirstResponder()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postPressed(_ sender: UIButton) {
        // Get userId of current logged in user
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        // Get the inputted message text
        guard let postText = self.postTextView.text, postTextView.text.isEmpty == false else {
            return
        }
        
        // Reference to Realtime Database
        let reference = Database.database().reference()
        // Reference to Storage
        let storageRef = Storage.storage().reference(forURL: "gs://animedia-7ff8a.appspot.com")
        
        // Reference to Posts child in realtime database
        let post = reference.child("posts").childByAutoId()
        // Reference to Posts child in Storage
        let storageImageRef = storageRef.child("posts").child(userId).child("\(post.key).jpg")
        
        // If the user decides to post without selecting a image
        if postImageView.image == nil {
            // Create the post dictionary info
            let dataArray: [String: Any] = [
                "username": "User",
                "pathToImage": "None",
                "postText": postText,
                "userID": userId,
                "postID": post.key,
            ]
            
            // Save post info to database
            post.setValue(dataArray)
            
            self.dismiss(animated: true, completion: nil)
        }
        // If the user decides to post and selected a image
        else {
            // Compressed the image
            guard let imageData = postImageView.image?.jpegData(compressionQuality: 0.4) else {
                return
            }
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            // Saving post image data to Storage
            let uploadPost = storageImageRef.putData(imageData, metadata: metaData) { (StorageMetadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                // Getting image url from Storage
                storageImageRef.downloadURL { (url, error) in
                    if let metaImageUrl = url?.absoluteString {
                        // Create the post dictionary info
                        let dataArray: [String: Any] = [
                            "username": "User",
                            "pathToImage": metaImageUrl,
                            "postText": postText,
                            "userID": userId,
                            "postID": post.key
                        ]
                        
                        // Save post info to database
                        post.setValue(dataArray)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            uploadPost.resume()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.postImageView.image = image
            //selectButton.isHidden = true
            //postButton.isHidden = false
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func picSelectPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
         
        //selectButton.isHidden = true
        
        //postImageView.af.setImage(withURL: URL(string: "https://screenmusings.org/movie/blu-ray/Your-Name/images/Your-Name-001.jpg")!)
    }
    
}
