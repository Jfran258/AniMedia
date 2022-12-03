//
//  SearchViewController.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/2/22.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var shows = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self
        
        navigationItem.backButtonTitle = ""

        searchField.becomeFirstResponder()
    }
    
    // When the user is typing in the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchShows()
        
        // Clears the searchfield afterwards
        //searchField.text = ""
        return true
    }
    
    // Get the show data
    func searchShows() {
        searchField.resignFirstResponder()
        
        guard let query = searchField.text, !query.isEmpty else {
            return
        }
        
        //let urlString = "https://api.jikan.moe/v4/anime?q=\(query)&sfw"
        let urlString = "https://api.jikan.moe/v4/anime?q=\(query)&order_by=members&sort=desc&sfw"
        
        // Taking care of spaces in query string
        let fixedURL = urlString.replacingOccurrences(of: " ", with: "%20")

        let request = URLRequest(url: URL(string: fixedURL)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // JSON Data as a data dictionary
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.shows = dataDictionary["data"] as! [[String:Any]]
                
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        if self.shows.count != 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
    }
    
    // The number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    // What to display at each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell to be displayed
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        // Get the show to be displayed
        let show = shows[indexPath.item]
        
        // Set title
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
        
        // Set episodes
        if let episodes = show["episodes"] as? Int {
            cell.episodesLabel.text = "(\(episodes) episodes)"
        } else {
            cell.episodesLabel.text = "N/A"
        }
        
        // Set type
        if let type = show["type"] as? String {
            cell.typeLabel.text = type
        } else {
            cell.typeLabel.text = "N/A"
        }
        
        // Set air date
        if let season = show["season"] as? String, let year = show["year"] as? Int {
            cell.airedLabel.text = "\(season.capitalized) \(year)"
        } else {
            if let year = show["year"] as? Int {
                print(year)
            } else {
                cell.airedLabel.text = " "
            }
        }
        
        // Get rid of tapped item highlight effect
        cell.selectionStyle = .none
        
        cell.posterView.layer.cornerRadius = 10
        
        return cell
    }
    
    // When a row is tapped on
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Create the view to be opened
        let animeDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "animeDetail") as! AnimeDetailsViewController
        
        // The selected show
        let show = shows[indexPath.item]
        
        // Passing selected show to details screen
        animeDetailsView.anime = show
        
        // segue to details screen
        self.navigationController?.pushViewController(animeDetailsView, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

