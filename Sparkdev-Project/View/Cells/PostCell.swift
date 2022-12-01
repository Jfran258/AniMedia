//
//  PostCell.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/24/22.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postBodyView: UIView!
    @IBOutlet weak var postProfileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    var likes = 0
    var isLiked = false
    
    @IBAction func likePressed(_ sender: UIButton) {
        isLiked.toggle()
        
        if isLiked {
            likes = likes + 1
            likeButton.setTitle("\(likes)", for: .normal)
            likeButton.configuration?.baseForegroundColor = UIColor.black
        } else {
            likes = likes - 1
            likeButton.setTitle("\(likes)", for: .normal)
            likeButton.configuration?.baseForegroundColor = UIColor.gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Dynamic Cell Height
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
}
