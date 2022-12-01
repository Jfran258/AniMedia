//
//  ProfileViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/15/22.
//

import UIKit
import Firebase
import FirebaseStorage
import AlamofireImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    

    @IBOutlet weak var Gear: UIBarButtonItem!
    @IBOutlet weak var usernameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        usernameView.layer.cornerRadius = 20
        var myImage = UIImage(named: "myImage")
        Gear.setBackgroundImage(myImage, for: .normal, barMetrics: .default)
        
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

            print(aUser.userName)
            print(aUser.bio)
            print(aUser.profileUrl)
            print(aUser.uid)
            
            let newUrl = URL(string: aUser.profileUrl)
            let newUrl2 = URL(string: aUser.backImage)
            
            self.usernameLabel.text = aUser.userName
            self.profileImage.af.setImage(withURL: newUrl!)
            self.backImage.af.setImage(withURL: newUrl2!)
            self.bioLabel.text = aUser.bio
        }
        
        
    }
    
    struct User {
        var userName: String
        var bio: String
        var uid: String
        var profileUrl: String
        var backImage: String
        
        init(withSnapShot: DataSnapshot) {
            let dict = withSnapShot.value as! [String: AnyObject]
            
            uid = withSnapShot.key
            userName = dict["username"] as! String
            bio = dict["bio"] as! String
            profileUrl = dict["profileImageUrl"] as! String
            backImage = dict["BackImageURL"] as! String
        }
    }
    
    @IBAction func didTapGear(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        print("TEXT2")
        vc.completionHandlerProfile = { text in
                self.usernameLabel.text = text
            
        }
        vc.completionHandlerBio = { text in
                self.bioLabel.text = text
            
        }
        vc.completionHandlerPicture = { text in
            let text2 = URL(string: text!)
            self.profileImage.af.setImage(withURL: text2!)
        }
        vc.completionHandlerBackPicture = { text in
            let text3 = URL(string: text!)
            self.backImage.af.setImage(withURL: text3!)
        }
        //present(vc, animated: true)
    }
    

}
