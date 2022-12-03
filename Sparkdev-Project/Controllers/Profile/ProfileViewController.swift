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

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var showsLink = ["https://cdn.myanimelist.net/images/anime/1208/94745l.jpg", "https://cdn.myanimelist.net/images/anime/1935/127974l.jpg", "https://cdn.myanimelist.net/images/anime/1517/100633l.jpg", "https://cdn.myanimelist.net/images/anime/1337/99013l.jpg"]
    var showTitles = ["Fullmetal Alchemist: Brotherhood", "Steins;Gate", "Attack on Titan Season 3", "Hunter x Hunter"]
    
    var mangaLinks = ["https://cdn.myanimelist.net/images/manga/1/157897l.jpg","https://cdn.myanimelist.net/images/manga/2/253146l.jpg","https://cdn.myanimelist.net/images/manga/3/266834l.jpg"]
    var mangaTitles = ["Berserk","One Piece","Oyasumi Punpun"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        if collectionView == self.favoriteShowsCollectionView {
            return showsLink.count
        } else if collectionView == self.favoriteMangaCollectionView {
            return mangaLinks.count
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // What to display for the currently airing row
        if collectionView == self.favoriteShowsCollectionView {
            let cell = favoriteShowsCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteShowCell", for: indexPath) as! FavoriteShowsCell
            
            cell.showImage.af.setImage(withURL: URL(string: showsLink[indexPath.item])!)
            
            cell.showImage.layer.cornerRadius = 10
            cell.showTitleLabel.text = showTitles[indexPath.item]
    
            return cell
        } else if collectionView == self.favoriteMangaCollectionView {
            // Create the cell to be displayed
            let cell = favoriteMangaCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteMangaCell", for: indexPath) as! FavoriteMangaCell
            
            cell.mangaImage.af.setImage(withURL: URL(string: mangaLinks[indexPath.item])!)
            
            cell.mangaImage.layer.cornerRadius = 10
            cell.mangaTitle.text = mangaTitles[indexPath.item]

            return cell
        } else {
            // Create the cell to be displayed
            let cell = favoriteShowsCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteShowCell", for: indexPath) as! FavoriteShowsCell
            
            //cell.posterView?.layer.cornerRadius = 10
            
            return cell
        }
        
        //return cell
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var favoriteShowsCollectionView: UICollectionView!
    
    @IBOutlet weak var favoriteMangaCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        //profileImage.layer.cornerRadius = 12
        favoriteShowsCollectionView.delegate = self
        favoriteShowsCollectionView.dataSource = self
        
        favoriteMangaCollectionView.delegate = self
        favoriteMangaCollectionView.dataSource = self
        
        getUserData()
    }
    
    func getUserData() {
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

            print(aUser.userName)
            print(aUser.bio)
            print(aUser.profileUrl)
            print(aUser.uid)
            //print(aUser.backImage)
            
            let newUrl = URL(string: aUser.profileUrl)
            //let newUrl2 = URL(string: aUser.backImage)
            
            self.usernameLabel.text = aUser.userName
            self.profileImage.af.setImage(withURL: newUrl!)
            //self.backImage.af.setImage(withURL: newUrl2!)
            self.bioLabel.text = aUser.bio
        }
        
        
    }
    
    struct User {
        var userName: String
        var bio: String
        var uid: String
        var profileUrl: String
        //var backImage: String
        
        init(withSnapShot: DataSnapshot) {
            let dict = withSnapShot.value as! [String: AnyObject]
            
            uid = withSnapShot.key
            userName = dict["username"] as! String
            bio = dict["bio"] as! String
            profileUrl = dict["profileImageUrl"] as! String
            //backImage = dict["BackImageURL"] as! String
        }
    }
    
    @IBAction func didTapGear(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen

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
    }
    

}
