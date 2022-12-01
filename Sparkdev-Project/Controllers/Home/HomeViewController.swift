//
//  HomeViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/24/22.
//

import UIKit
import Firebase
import AlamofireImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [Post]()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        navigationItem.backButtonTitle = ""
        
        getPosts()
        
        //refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        //postsTableView.refreshControl = refreshControl
        //refreshControl.tintColor = .white
    }
    
    func getPosts() {
        //posts.removeAll()
        
        // Reference to database
        let databaseRef = Database.database().reference()

        // Grabbing all the posts
        databaseRef.child("posts").observe(.childAdded) { (snapshot) in
            // Getting each post
            if let dataArray = snapshot.value as? [String: Any] {
                // Getting the post data
                if let userId = dataArray["userID"] as? String, let userName = dataArray["username"] as? String, let postText = dataArray["postText"] as? String, let postId = dataArray["postID"] as? String, let pathToImage = dataArray["pathToImage"] as? String  {
                    
                    // Creating post object
                    let post = Post(userName: userName, uid: userId, postText: postText, imageUrl: pathToImage, postId: postId)
                    
                    print(post.imageUrl)
                    
                    // Add post to posts array
                    self.posts.insert(post, at: 0)
                    
                    // Update the table view
                    self.postsTableView.reloadData()
                    
                    self.refreshControl.endRefreshing()
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
            
            let newUrl = URL(string: aUser.profileUrl)
            
            cell.usernameLabel.text = aUser.userName
            cell.postProfileImage.af.setImage(withURL: newUrl!)
            
            cell.postProfileImage.layer.masksToBounds = false
            cell.postProfileImage.layer.cornerRadius = cell.postProfileImage.frame.size.width / 2
            cell.postProfileImage.clipsToBounds = true
        }

        cell.postText.text = post.postText
        
        cell.postBodyView.layer.cornerRadius = 15
        cell.postBodyView.layer.borderWidth = 1.0
        cell.postBodyView.layer.masksToBounds = false
        cell.postBodyView.clipsToBounds = true
        
        // If imageUrl is None, make imageview height 0. Otherwise display image as normal
        if post.imageUrl == "None" {
            //cell.postImage.image = nil
            cell.postImageHeightConstraint.constant = 0
            //cell.layoutIfNeeded()
        } else {
            cell.postImage.layer.cornerRadius = 10
            //cell.postImage.heightAnchor.constraint(equalToConstant: CGFloat(60)).isActive = true

            cell.postImage.af.setImage(withURL: URL(string: post.imageUrl)!)
            cell.postImageHeightConstraint.constant = 198
        }
        //cell.postImage.af.setImage(withURL: URL(string: post.imageUrl)!)
        //cell.postImage.heightAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        //cell.postImageHeightConstraint.constant = 0
        cell.selectionStyle = .none
        
        return cell
    }
    
    // When a row is tapped on
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Create the view to be opened
        let postDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "postDetails") as! PostViewController
        
        // The selected show
        let post = posts[indexPath.item]
        
        // Passing selected post to post details screen
        postDetailsView.post = post
        
        // segue to details screen
        self.navigationController?.pushViewController(postDetailsView, animated: true)
    }
}
