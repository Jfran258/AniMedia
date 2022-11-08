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
        if let title = anime["title_english"] as? String {
            titleLabel.text = title
        } else {
            if let title = anime["title"] as? String {
                titleLabel.text = title
            }
        }
        //titleLabel.text = anime["title"] as! String
        
        // Set synopsis
        if let synopsis = anime["synopsis"] as? String {
            synopsisLabel.text = synopsis
        } else {
            synopsisLabel.text = "N/A"
        }
        
        // Trailer URL
        if let trailer = anime["trailer"] as? [String: AnyObject] {
            if let url = trailer["url"] as? String {
                print(url)
                if let videoId = url.components(separatedBy: "=").last {
                    print(videoId)
                }
            }
        }
    }
    
    // Hides tab bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
