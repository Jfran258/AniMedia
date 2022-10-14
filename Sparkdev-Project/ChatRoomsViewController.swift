//
//  ChatRoomsViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/9/22.
//

import UIKit
import Firebase

class ChatRoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roomsTableView: UITableView!
    
    var rooms = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        
        // Make back button title blank
        navigationItem.backButtonTitle = ""
        
        // Loading the rooms from Firebase into our view
        getRooms()
    }
    
    // For getting the rooms saved from Firebase
    func getRooms() {
        // Reference to database
        let databaseRef = Database.database().reference()
        
        // Grabbing all the rooms
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            // Getting Each Room
            if let dataArray = snapshot.value as? [String: Any] {
                // Getting the room name
                if let roomName = dataArray["roomName"] as? String {
                    // Creating room object with unique id and the received room name
                    let room = Room.init(roomId: snapshot.key, roomName: roomName)
                    
                    // Add room to rooms array
                    self.rooms.append(room)
                    
                    // Update the table view
                    self.roomsTableView.reloadData()
                }
            }
        }
    }
    
    // When a room is selected, open the chat room view
    @IBAction func roomSelected(_ sender: UIButton) {
        // Name of selected room
        let roomSelected = sender.titleLabel?.text
        
        // Creating the view
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomViewController
        
        // Iterate the rooms to find the selected room
        for room in rooms {
            // Found room
            if room.roomName == roomSelected {
                // Pass selected room to the chat room view
                chatRoomView.room = room
                break;
            }
        }
        
        self.navigationController?.pushViewController(chatRoomView, animated: true)
    }

    // What to display at each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get room name
        let room = rooms[indexPath.row]
        
        // Create the cell to be displayed
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        
        // Set the room name
        cell.roomButton.setTitle(room.roomName, for: .normal)

        return cell
    }
    
    // The number of rows to display in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
}
