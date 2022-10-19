//
//  ChatCell.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/12/22.
//

import UIKit

class ChatCell: UITableViewCell {

    enum bubbleType {
        case incoming
        case outgoing
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var chatTextBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTextBubble.layer.cornerRadius = 10
        
        //chatTextBubble.layer.shadowColor = UIColor.black.cgColor
        //chatTextBubble.layer.shadowOpacity = 1
        //chatTextBubble.layer.shadowRadius = 3
        //chatTextBubble.layer.shadowOffset = .zero
        //chatTextBubble.layer.masksToBounds = false
    }

    // Setting the message's username and message
    func setMessageData(message: Message) {
        userNameLabel.text = message.senderName
        chatTextView.text = message.messageText
    }
    
    // Setting the message bubble type (User and other users)
    func setBubbleType(type: bubbleType) {
        // If other user, make message bubble appear left side of screen, otherwise right side
        if (type == .incoming) {
            chatStack.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            chatTextView.textColor = .black
        } else if (type == .outgoing) {
            chatStack.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7647058824, blue: 1, alpha: 1)
            chatTextView.textColor = .white
            userNameLabel.text = ""
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
