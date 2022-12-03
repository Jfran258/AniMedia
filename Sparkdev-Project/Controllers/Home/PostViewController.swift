//
//  PostViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/27/22.
//

import UIKit
import Firebase
import AlamofireImage

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var postBodyView: UIView!
    @IBOutlet weak var posterProfilePicView: UIImageView!
    @IBOutlet weak var posterUsernameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postBodyHeightConstraint: NSLayoutConstraint!
    
    var post: Post!
    
    var comments = [Comment]()
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                 view.addGestureRecognizer(tapGesture)

        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to current user
        let userRef = databaseRef.child("users").child(post.uid)
        
        // Accessing information for that user
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Create User object
            let aUser = User(withSnapShot: snapshot)
            
            // Set post owner username
            self.posterUsernameLabel.text = aUser.userName
            
            // Set post owner profile pic
            let newUrl = URL(string: aUser.profileUrl)
            self.posterProfilePicView.af.setImage(withURL: newUrl!)
            
            // Making profile pic round
            self.posterProfilePicView.layer.masksToBounds = false
            self.posterProfilePicView.layer.cornerRadius = self.posterProfilePicView.frame.size.width / 2
            self.posterProfilePicView.clipsToBounds = true
            
            // Set text of post
            self.postTextLabel.text = self.post.postText
            
            self.title = "\(aUser.userName)'s Post"
        }
        
        // Set post image
        if post.imageUrl == "None" {
            postImageView.af.setImage(withURL: URL(string: post.imageUrl)!)
            postImageViewHeightConstraint.constant = 0
            postBodyHeightConstraint.constant = 134
        } else {
            postImageView.af.setImage(withURL: URL(string: post.imageUrl)!)
            postImageView.layer.cornerRadius = 10
            postBodyHeightConstraint.constant = 380
        }
        
        let thickness: CGFloat = 2.0
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.postBodyView.frame.size.height - thickness, width: self.postBodyView.frame.size.width, height: thickness)
        bottomBorder.backgroundColor = UIColor.darkGray.cgColor
        //bottomBorder.borderWidth = 1
        
        //postBodyView.layer.addSublayer(bottomBorder)
        
        getComments()
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        print(hour)
        print(minutes)
    }
    
    // Getting the comments from Firebase
    func getComments() {
        // Get postId of current post
        guard let postId = post?.postId else {
            return
        }
        
        let databaseRef = Database.database().reference()
        
        // Accessing the saved comments of current post
        databaseRef.child("posts").child(postId).child("comments").observe(.childAdded) { (snapshot) in
            // Parsing the comments into a dictionary array
            if let dataArray = snapshot.value as? [String: Any] {
                // Checking for valid user and message
                guard let senderName = dataArray["userName"] as? String, let messageText = dataArray["text"] as? String, let userId = dataArray["UserID"] as? String else {
                    return
                }
                
                print(messageText)
                let comment = Comment.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
                
                self.comments.append(comment)
                
                self.commentsTableView.reloadData()
            }
        }
    }
    
    // Handles sending comments to Firebase
    func postComment(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Getting reference to current user by using userId
        let user = databaseRef.child("users").child(userId)
        
        // Observe updates made by current user
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            // Getting username of user
            if let userName = snapshot.value as? String {
                print(userName)
                // Getting the postId of current post
                if let postId = self.post?.postId {
                    print(postId)
                    let dataArray: [String: Any] = ["UserID": userId, "text": text, "userName": userName]
                    
                    // Reference to the current post
                    let post = databaseRef.child("posts").child(postId)
                    
                    // Adding comment to database
                    post.child("comments").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                        if (error) == nil {
                            // Reset text field
                            self.commentTextField.text = ""
                            
                            print("Comment added to database")
                        }
                    })
                }
            }
        }
    }
    
    // When the send button is pressed
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        // Checking if the comment text field has info/not empty
        guard let chatText = self.commentTextField.text, chatText.isEmpty == false else {
            return
        }
        
        postComment(text: chatText)
    }
    
    // The number of comments
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // Displaying each comment at each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get comment
        let comment = self.comments[indexPath.row]
        
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        cell.commentLabel.text = comment.messageText
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to current user
        let userRef = databaseRef.child("users").child(comment.userId!)
        
        // Accessing information for that user
        userRef.observeSingleEvent(of: .value) { snapshot in
            // Create User object
            let aUser = User(withSnapShot: snapshot)
            
            let newUrl = URL(string: aUser.profileUrl)

            // Display profile pic of commentater
            cell.profileImageView.af.setImage(withURL: newUrl!)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            
            cell.usernameLabel.text = aUser.userName
        }
        
        return cell
    }
}
