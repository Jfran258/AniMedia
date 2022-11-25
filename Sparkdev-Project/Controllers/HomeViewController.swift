//
//  HomeViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/24/22.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts = [Post]()
    
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        getPosts()
    }
    
    func getPosts() {
        // Reference to database
        let databaseRef = Database.database().reference()

        // Grabbing all the posts
        databaseRef.child("posts").observe(.childAdded) { (snapshot) in
            // Getting Each post
            if let dataArray = snapshot.value as? [String: Any] {
                // Getting the post data
                if let userId = dataArray["userID"] as? String, let userName = dataArray["username"] as? String, let postText = dataArray["postText"] as? String, let postId = dataArray["postID"] as? String, let pathToImage = dataArray["pathToImage"] as? String  {
                    
                    // Creating post object
                    let post = Post(userName: userName, uid: userId, postText: postText, imageUrl: pathToImage, postId: postId)
                    
                    // Add post to posts array
                    self.posts.insert(post, at: 0)
                    
                    // Update the table view
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        
        let post = posts[indexPath.row]
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to current user
        let userRef = databaseRef.child("users").child(post.uid)
  
        // Accessing information for that user
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Create User object
            let aUser = User(withSnapShot: snapshot)
            print(aUser)

            print(aUser.userName)
            print(aUser.bio)
            print(aUser.profileUrl)
            print(aUser.uid)
            
            let newUrl = URL(string: aUser.profileUrl)
            
            cell.usernameLabel.text = aUser.userName
            cell.postProfileImage.af.setImage(withURL: newUrl!)
            
            cell.postProfileImage.layer.masksToBounds = false
            cell.postProfileImage.layer.cornerRadius = cell.postProfileImage.frame.size.width / 2
            cell.postProfileImage.clipsToBounds = true
        }

        cell.postText.text = post.postText
        //cell.postText.sizeToFit()
        
        cell.postBodyView.layer.cornerRadius = 15
        cell.postBodyView.layer.borderWidth = 1.0
        cell.postBodyView.layer.masksToBounds = false
        cell.postBodyView.clipsToBounds = true
        
        return cell
    }
}
