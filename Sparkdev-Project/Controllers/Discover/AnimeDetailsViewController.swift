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

        // Do any additional setup after loading the view.
        titleLabel.text = anime["title"] as! String
        //synopsisLabel.text = anime["synopsis"] as! String
        
        // If not nil
        if let synopsis = anime["synopsis"] as? String {
            synopsisLabel.text = synopsis
        } else {
            synopsisLabel.text = "N/A"
        }
        //print(anime["season"] as! String)
        
        
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
