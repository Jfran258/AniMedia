//
//  CreateChatViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/9/22.
//

import UIKit
import Firebase

class CreateChatViewController: UIViewController {

    @IBOutlet weak var newRoomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                 view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    // Creating the chat room and saving it to Firebase
    @IBAction func createRoomPressed(_ sender: UIButton) {
        // Get the inputted name
        guard let roomName = self.newRoomTextField.text, roomName.isEmpty == false else {
            return
        }
        
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Reference to "rooms" child
        let room = databaseRef.child("rooms").childByAutoId()
        
        // Create Room dictionary with given name
        let dataArray:[String: Any] = ["roomName": roomName]
        
        // Add dictionary to that child
        room.setValue(dataArray) { error, ref in
            if (error == nil) {
                // Reset text field
                self.newRoomTextField.text = ""
            }
        }
        
        // Dismiss screen
        self.dismiss(animated: true, completion: nil)
    }
}
