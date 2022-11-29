//
//  PostViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/27/22.
//

import UIKit
import Firebase
import AlamofireImage

class PostViewController: UIViewController {
    @IBOutlet weak var posterProfilePicView: UIImageView!
    @IBOutlet weak var posterUsernameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to current user
        let userRef = databaseRef.child("users").child(post.uid)
  
        // Accessing information for that user
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Create User object
            let aUser = User(withSnapShot: snapshot)

            print(aUser.userName)
            print(aUser.bio)
            print(aUser.profileUrl)
            print(aUser.uid)
            
            let newUrl = URL(string: aUser.profileUrl)
            
            
            self.posterUsernameLabel.text = aUser.userName
            self.posterProfilePicView.af.setImage(withURL: newUrl!)
            
            self.posterProfilePicView.layer.masksToBounds = false
            self.posterProfilePicView.layer.cornerRadius = self.posterProfilePicView.frame.size.width / 2
            self.posterProfilePicView.clipsToBounds = true
            
            self.postTextLabel.text = self.post.postText
            
            self.title = "\(aUser.userName)'s Post"
        }
    }
}
