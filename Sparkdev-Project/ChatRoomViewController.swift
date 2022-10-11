//
//  ChatRoomViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/9/22.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    @IBOutlet weak var chatTextField: UITextField!
    
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Sets title of room
        title = room?.roomName
        
        //chatTextField.layer.cornerRadius = 35.0
        //messageTextField.layer.borderWidth = 2.0
        //self.navigationItem.backBarButtonItem?.title = ""
    }
    
    // Sending messages
    @IBAction func sendButtonPressed(_ sender: UIButton) {        
        // Checking if the chat text field has info/not empty
        guard let chatText = self.chatTextField.text, chatText.isEmpty == false, let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Getting reference to current user by using userId
        let user = databaseRef.child("users").child(userId)
        
        // Observes updates made by user
        user.child("username").observeSingleEvent(of: .value) { (snapshot) in
            // Getting username of user
            if let userName = snapshot.value as? String {
                // Getting the roomId of the room
                if let roomId = self.room?.roomId {
                    // Message dictionary with user and their message
                    let dataArray: [String: Any] = ["senderName": userName, "text": chatText]
                    
                    // Reference to the room currently in
                    let room = databaseRef.child("rooms").child(roomId)
                    
                    // Adding message to database
                    room.child("messages").childByAutoId().setValue(dataArray, withCompletionBlock: { (error, ref) in
                        
                        if (error) == nil {
                            // Reset text field
                            self.chatTextField.text = ""
                            
                            print("Message added to database")
                        }
                    })
                }
            }
        }
    }
}
