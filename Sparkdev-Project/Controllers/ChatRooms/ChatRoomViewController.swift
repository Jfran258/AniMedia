//
//  ChatRoomViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/9/22.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTextField: UITextField!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var room: Room?
    
    var chatMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                 view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
        
        // Sets title of room
        title = room?.roomName
        
        // Text Field attributes
        chatTextField.layer.cornerRadius = 20.0
        chatTextField.clipsToBounds = true

        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // Load the messages into the view
        getMessages()
    }
    
    // Getting the messages from Firebase
    func getMessages() {
        
        guard let roomid = room?.roomId else {
            return
        }
        
        let databaseRef = Database.database().reference()
        
        // Accessing the saved messages
        databaseRef.child("rooms").child(roomid).child("messages").observe(.childAdded) { (snapshot) in
            // Parsing the messages from Firebase into a dictionary
            if let dataArray = snapshot.value as? [String: Any] {
                // Checking for valid user and message
                guard let senderName = dataArray["senderName"] as? String, let messageText = dataArray["text"] as? String, let userId = dataArray["senderId"] as? String else {
                    return
                }
                
                // Creating message object from received user and message
                let message = Message.init(messageKey: snapshot.key, senderName: senderName, messageText: messageText, userId: userId)
                
                // Add message to chatMessages array
                self.chatMessages.append(message)
                
                // Reload table view
                self.chatTableView.reloadData()
                
                let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                
                self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    // Handles sending messages to Firebase
    func sendMessage(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
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
                if let roomId = self.room?.roomId, let userId = Auth.auth().currentUser?.uid {
                    // Message dictionary with user and their message
                    let dataArray: [String: Any] = ["senderName": userName, "text": text, "senderId": userId]
                    
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
    
    // When the send button is pressed
    @IBAction func sendButtonPressed(_ sender: UIButton) {        
        // Checking if the chat text field has info/not empty
        guard let chatText = self.chatTextField.text, chatText.isEmpty == false else {
            return
        }
        
        sendMessage(text: chatText)
    }
    
    // What to display at each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get message
        let message = self.chatMessages[indexPath.row]
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell

        // Set message data
        cell.setMessageData(message: message)
        
        // Set user's message bubble
        if (message.userId == Auth.auth().currentUser?.uid) {
            cell.setBubbleType(type: .outgoing)
        } else {
            cell.setBubbleType(type: .incoming)
        }
        
        return cell
    }
    
    // The number of rows to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    
}
