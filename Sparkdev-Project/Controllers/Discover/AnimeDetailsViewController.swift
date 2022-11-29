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
    
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var studiosLabel: UILabel!
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        //self.navigationController?.navigationBar.isTranslucent = true
        
        //let appearance = UINavigationBarAppearance()
        //appearance.backgroundColor = UIColor.red
        //navigationController?.navigationBar.scrollEdgeAppearance = appearance
        backgroundView.layer.borderWidth = 0

        
        // Set the poster
        if let images = anime["images"] as? [String: AnyObject] {
            if let jpg = images["jpg"] {
                if let imageUrl = jpg["large_image_url"] as? String {
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
        } else {
            if let title = anime["title"] as? String {
                titleLabel.text = title
                self.title = title
            }
        }
         
        // Score
        if let score = anime["score"] as? Double {
            print(score)
        } else {
            print("NA")
        }
        
        // Set type
        if let type = anime["type"] as? String {
            typeLabel.text = "\(type)"
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
            seasonLabel.text = "\(season.capitalized) \(year)"
        } else {
            if let aired = anime["aired"] as? [String: AnyObject] {
                if let string = aired["string"] as? String {
                    seasonLabel.text = string
                }
            } else {
                seasonLabel.text = "?"
            }
        }
        
        // Set studio
        if let studios = anime["studios"] as? [[String: Any]] {
            var theStudios = [String]()
            for studio in studios {
                theStudios.append(studio["name"] as! String)
            }
            print()
            
            
            studiosLabel.text = theStudios.joined(separator: ", ")
            studiosLabel.sizeToFit()
            /*
            // Check if studios exist
            if studios.count != 0 {
                let studio = studios[0]["name"] as? String
                studiosLabel.text = studio
            } else {
                studiosLabel.text = "??"
            }
            */
        } else {
            studiosLabel.text = "?"
        }
        
        // Set genres
        if let genres = anime["genres"] as? [[String: Any]] {
            var theGenres = [String]()
            for genre in genres {
                theGenres.append(genre["name"] as! String)
            }
            
            genresLabel.text = theGenres.joined(separator: ", ")
            genresLabel.sizeToFit()
        }
        
        // Set synopsis
        if let synopsis = anime["synopsis"] as? String {
            synopsisLabel.text = synopsis
        } else {
            synopsisLabel.text = "To be added."
        }
        
        // Set the trailer
        if let trailer = anime["trailer"] as? [String: AnyObject] {
            // Get trailer URL
            if let videoId = trailer["youtube_id"] as? String {
                playerView.load(withVideoId: videoId, playerVars: ["playsinline" : 0])
            }
        }
    }
    
    // Hides tab bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}
