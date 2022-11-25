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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
