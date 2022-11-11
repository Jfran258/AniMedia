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
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    //@IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        //navBarAppearance.backgroundColor = .tintColor
        //navigationController?.navigationBar.standardAppearance = navBarAppearance
        //navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        //UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        //self.navigationController?.navigationBar.isTranslucent = true

        backgroundView.layer.borderWidth = 0
        //navigationController?.navigationBar.backgroundColor = UIColor(red: 31.0, green: 35.0, blue: 41.0, alpha: 1.0)
        //navigationController?.navigationBar.backgroundColor = UIColor.black
        //navigationController?.navigationBar.tintColor = UIColor.black
        //navigationController?.navigationBar.tintColor = UIColor.white
        //navigationController?.hidesBarsOnSwipe = true
        //navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        
        
        
        
        // Set the poster
        if let images = anime["images"] as? [String: AnyObject] {
            if let jpg = images["jpg"] {
                if let imageUrl = jpg["image_url"] as? String {
                    let newUrl = URL(string: imageUrl)
                    posterView.af.setImage(withURL: newUrl!)
                    
                    posterView.layer.cornerRadius = 10
                
                    //posterView.layer.shadowColor = UIColor.black.cgColor
                    //posterView.layer.shadowOffset = CGSize(width: 2, height: 2)
                    //posterView.layer.shadowOpacity = 0.8
                    //posterView.layer.shadowRadius = 5
                    
                    posterView.layer.borderWidth = 0.5
                }
            }
        }
        
        // Set title
        if let title = anime["title_english"] as? String {
            titleLabel.text = title
            self.title = title
            //titleLabel.sizeToFit()
        } else {
            if let title = anime["title"] as? String {
                titleLabel.text = title
            }
        }
         
        // Score
        if let score = anime["score"] as? Double {
            //titleLabel.text = title
            print(score)
        } else {
            print("NA")
        }
        
        // Set type
        if let episodes = anime["type"] as? String {
            typeLabel.text = "\(episodes)"
        } else {
            typeLabel.text = "?"
        }
        
        // Set episodes
        if let episodes = anime["episodes"] as? Int {
            episodesLabel.text = "\(episodes)"
        } else {
            episodesLabel.text = "?"
        }
        
        // Set air date
        if let season = anime["season"] as? String, let year = anime["year"] as? Int {
            //print("\(season.capitalized) \(year)")
            seasonLabel.text = "\(season.capitalized) \(year)"
        } else {
            seasonLabel.text = "?"
        }
        
        // Set studio
        if let studios = anime["studios"] as? [[String: Any]] {
            
            for studio in studios {
                print(studio["name"] as! String, terminator: " ")
            }
            /*
            // Check if studios exist
            if studios.count != 0 {
                let studio = studios[0]["name"] as? String
                seasonLabel.text = studio
            } else {
                seasonLabel.text = "?"
            }
            */
        } else {
            //seasonLabel.text = "?"
        }
        
        // Set synopsis
        if let synopsis = anime["synopsis"] as? String {
            synopsisLabel.text = synopsis
            //synopsisLabel.sizeToFit()
        } else {
            synopsisLabel.text = "To be added."
        }
        
        // Set the trailer
        if let trailer = anime["trailer"] as? [String: AnyObject] {
            // Get trailer URL
            if let url = trailer["url"] as? String {
                // Get the video ID
                if let videoId = url.components(separatedBy: "=").last {
                    // Loading player with videoId
                    //playerView.load(withVideoId: videoId)
                }
            }
        }
    }
    
    // Hides tab bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
}
