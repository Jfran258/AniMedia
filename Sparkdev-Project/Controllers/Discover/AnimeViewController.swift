//
//  ViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 10/20/22.
//

import UIKit
import AlamofireImage

class AnimeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var currentlyAiringCollectionView: UICollectionView!
    
    @IBOutlet weak var upcomingShowsCollectionView: UICollectionView!
    
    @IBOutlet weak var topShowsCollectionView: UICollectionView!
    
    var currentlyAiringShows = [[String:Any]]()
    var upcomingShows = [[String:Any]]()
    var topShows = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentlyAiringCollectionView.delegate = self
        currentlyAiringCollectionView.dataSource = self
        
        upcomingShowsCollectionView.delegate = self
        upcomingShowsCollectionView.dataSource = self
        
        topShowsCollectionView.delegate = self
        topShowsCollectionView.dataSource = self
        
        navigationItem.backButtonTitle = ""
        
        //https://api.jikan.moe/v4/seasons/2022/summer
        //https://api.jikan.moe/v4/top/manga
        getShowsData(urlString: "https://api.jikan.moe/v4/seasons/now", showData: "currentlyAiringShows")
        getShowsData(urlString: "https://api.jikan.moe/v4/seasons/upcoming", showData: "upcomingShows")
        getShowsData(urlString: "https://api.jikan.moe/v4/top/anime?filter=bypopularity", showData: "topShows")
        //getShowsData(urlString: "https://api.jikan.moe/v4/top/anime", showData: "topShows")
    }
    
    // Function for parsing JSON data from given API url
    func getShowsData(urlString: String, showData: String) {
        // URL of API to parse JSON from
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // JSON Data as a data dictionary
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Save the currently airing shows JSON Data to the currently airing shows array.
                if showData == "currentlyAiringShows" {
                    self.currentlyAiringShows = dataDictionary["data"] as! [[String:Any]]
                    
                    self.currentlyAiringCollectionView.reloadData()
                }
                // Save the upcoming shows JSON Data to the upcoming shows array.
                else if showData == "upcomingShows" {
                    self.upcomingShows = dataDictionary["data"] as! [[String:Any]]
                    
                    self.upcomingShowsCollectionView.reloadData()
                }
                // Save the top shows JSON Data to the top shows array.
                else if showData == "topShows" {
                    self.topShows = dataDictionary["data"] as! [[String:Any]]
                    
                    self.topShowsCollectionView.reloadData()
                }
                
                // Accessing Nested JSON Data
                for show in self.topShows {
                    // Show title
                    let title = show["title"] as! String
                    //print(title)
                    
                    // Synopsis
                    let synopsis = show["synopsis"]// as! String
                    //print(synopsis)
                
                    // Image URL
                    if let images = show["images"] as? [String: AnyObject] {
                        if let jpg = images["jpg"] {
                            //print(jpg["image_url"] as! String)
                        }
                    }
                    
                    // Season
                    let season = show["season"]// as! String
                    
                    // Year
                    let year = show["year"]// as! Int
                    
                    //print("\(season.capitalized) \(year)")
                    
                    let episodes = show["episodes"]
                    //print(episodes!)
                    
                    if let studios = show["studios"] as? [[String: Any]] {
                        for studio in studios {
                            //print(studio["name"] as! String, terminator: " ")
                        }
                    }
                    //print()
                    
                    //var genrelist: [String] = []
                    if let genres = show["genres"] as? [[String: Any]] {
                        for genre in genres {
                            //print(genre["name"] as! String, terminator: " ")
                        }
                    }
                    
                    //print()
                    //print()
                }
            }
        }
        
        task.resume()
    }
    
    // The number of items to display in a collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.currentlyAiringCollectionView {
            return currentlyAiringShows.count
        } else if collectionView == self.upcomingShowsCollectionView {
            return upcomingShows.count
        } else if collectionView == self.topShowsCollectionView {
            return topShows.count
        } else {
            return 4
        }
    }
    
    // What to display at each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // What to display for the currently airing row
        if collectionView == self.currentlyAiringCollectionView {
            // Create the cell to be displayed
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentlyAiringShowCell", for: indexPath) as! CurrentlyAiringShowCell
            
            // Get the show to be displayed at that cell
            let show = currentlyAiringShows[indexPath.item]

            // Set the title
            if let title = show["title_english"] as? String {
                cell.titleLabel.text = title
            } else {
                if let title = show["title"] as? String {
                    cell.titleLabel.text = title
                }
            }

            // Set the poster
            if let images = show["images"] as? [String: AnyObject] {
                if let jpg = images["jpg"] {
                    if let imageUrl = jpg["large_image_url"] as? String {
                        let newUrl = URL(string: imageUrl)
                        cell.posterView.af.setImage(withURL: newUrl!)
                    }
                }
            }
            
            cell.posterView.layer.cornerRadius = 10
            
            return cell
        }
        // What to display for the upcoming shows row
        else if collectionView == self.upcomingShowsCollectionView {
            // Create the cell to be displayed
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingShowCell", for: indexPath) as! UpcomingShowCell
            
            // Get the show
            let show = upcomingShows[indexPath.item]

            // Set the title
            if let title = show["title_english"] as? String {
                cell.titleLabel.text = title
            } else {
                if let title = show["title"] as? String {
                    cell.titleLabel.text = title
                }
            }
            
            // Set the poster
            if let images = show["images"] as? [String: AnyObject] {
                if let jpg = images["jpg"] {
                    if let imageUrl = jpg["large_image_url"] as? String {
                        let newUrl = URL(string: imageUrl)
                        cell.posterView.af.setImage(withURL: newUrl!)
                    }
                }
            }
            
            cell.posterView.layer.cornerRadius = 10
            
            return cell
        }
        // What to display for the top shows row
        else if collectionView == self.topShowsCollectionView {
            // Create the cell to be displayed
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopShowCell", for: indexPath) as! TopShowCell
            
            // Get the show
            let show = topShows[indexPath.item]

            // Set the title
            if let title = show["title_english"] as? String {
                cell.titleLabel.text = title
            } else {
                if let title = show["title"] as? String {
                    cell.titleLabel.text = title
                }
            }
            
            // Set the poster
            if let images = show["images"] as? [String: AnyObject] {
                if let jpg = images["jpg"] {
                    if let imageUrl = jpg["large_image_url"] as? String {
                        let newUrl = URL(string: imageUrl)
                        cell.posterView.af.setImage(withURL: newUrl!)
                    }
                }
            }
            
            cell.posterView.layer.cornerRadius = 10
            
            return cell
        } else {
            // Create the cell to be displayed
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeGridCell", for: indexPath) as! CurrentlyAiringShowCell
            
            //cell.posterView?.layer.cornerRadius = 10
            
            return cell
        }
    }
    
    // When the user taps on a poster, the details screen is opened
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // When a show from the currently airing row is selected
        if collectionView == self.currentlyAiringCollectionView {
            // Create the view to be opened
            let animeDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "animeDetail") as! AnimeDetailsViewController
            
            // The selected show
            let show = currentlyAiringShows[indexPath.item]
            
            // Passing selected show to details screen
            animeDetailsView.anime = show
            
            // segue to details screen
            self.navigationController?.pushViewController(animeDetailsView, animated: true)
        }
        // When a show from the upcoming shows row is selected
        else if collectionView == self.upcomingShowsCollectionView {
            let animeDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "animeDetail") as! AnimeDetailsViewController
            
            // The selected show
            let show = upcomingShows[indexPath.item]
            
            // Passing selected show to details screen
            animeDetailsView.anime = show
            
            // segue to details screen
            self.navigationController?.pushViewController(animeDetailsView, animated: true)
        }
        // When a show from the top shows row is selected
        else if collectionView == self.topShowsCollectionView {
            let animeDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "animeDetail") as! AnimeDetailsViewController
            
            // The selected show
            let show = topShows[indexPath.item]
            
            // Passing selected show to details screen
            animeDetailsView.anime = show
            
            // segue to details screen
            self.navigationController?.pushViewController(animeDetailsView, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
