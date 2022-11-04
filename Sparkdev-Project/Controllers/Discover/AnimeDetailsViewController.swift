//
//  AnimeDetailsViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/23/22.
//

import UIKit
import AlamofireImage
import youtube_ios_player_helper

class AnimeDetailsViewController: UIViewController {
  
    var anime: [String:Any]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set title
        titleLabel.text = anime["title"] as! String
        
        // Set synopsis
        if let synopsis = anime["synopsis"] as? String {
            synopsisLabel.text = synopsis
        } else {
            synopsisLabel.text = "N/A"
        }
        
        
    }
    
    // Hides tab bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
