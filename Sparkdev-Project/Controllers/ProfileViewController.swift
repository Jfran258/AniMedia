//
//  ProfileViewController.swift
//  Sparkdev-Project
//
//  Created by Julian Arias on 11/10/22.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameProfile: UILabel!
    
    @IBOutlet weak var bioProfile: UILabel!
    
    var BioU: UserInfo?
    var UID = User?.self
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 31/255, green: 35/255, blue: 41/255, alpha: 1)

        
        bioProfile.layer.cornerRadius = 50
        
        GetInfo()
        
        database.child("users").observeSingleEvent(of: .value, with: {snapshot in
            guard let value = snapshot.value as? String else {
                return
            }
            print("Value: \(value)")
        })
        
    }
    func readValue() {
        database.child("bio").observeSingleEvent(of: .value) {snapshot in
            self.bioProfile = snapshot.value as? UILabel
        }
    }
    /*
    func readObject() {
        database.child("users").observe(.value) { snapshot in
            do {
                self.object = try snapshot.data(as: ObjectDemo.self)
            }
        }
    }
     */
    func GetInfo() {
        guard let BioId = BioU?.uid else {
            return
        }
        let databaseRef = Database.database().reference()
        
        databaseRef.child("users/\(User.self)/Bio").getData(completion: { error, snapshot in
            guard error == nil else {
            print(error!.localizedDescription)
            return
        }
            let BIOO = snapshot?.value as? String ?? "Unkown";
            self.bioProfile.text = BIOO
        });
        
        
        /*
        databaseRef.child("users").child(BioId).child("bio").observeSingleEvent(of: .value, with: { snapshot in
            
            // Parsing the messages from Firebase into a dictionary
            if let dataArray = snapshot.value as? [String: Any] {
                // Checking for valid user and message
                guard let senderName = dataArray["username"] as? String, let BioText = dataArray["bio"] as? String, let userId = dataArray["uid"] as? String else {
                    return
                }
                let Bio = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: BioText, userId: userId)
                
                // Add message to chatMessages array
                self.bioProfile.text = BioText
                
                // Reload table view
                //self.chatTableView.reloadData()
            }
        }) { error in
            print(error.localizedDescription)
        }
         */
    }
    
    @IBAction func didTapIcon(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
        //vc.modalPresentationStyle = .fullScreen
        vc.completionHandlerProfile = { text in
            self.usernameProfile.text = text
        }
        vc.completionHandlerBio = { text in
            self.bioProfile.text = text
        }
        //present(vc, animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
