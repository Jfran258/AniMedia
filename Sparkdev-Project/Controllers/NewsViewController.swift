//
//  NewsViewController.swift
//  Sparkdev-Project
//
//  Created by Jean Elias on 11/7/22.
//

import UIKit
import SwiftSoup

class NewsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table:UITableView!
    
    struct Images {
        let title: String
        let imageName: String
    }
    
    
    let data: [Images]=[
        Images(title: "a", imageName: "image1"),
        Images(title: "b", imageName: "image2"),
        Images(title: "c", imageName: "image3"),
        Images(title: "d", imageName: "image4"),
        Images(title: "e", imageName: "image5")

    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let images = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.label.text = images.title
        cell.iconImageView.image = UIImage(named: images.imageName)
        return cell
    }
    
  
    
    
    

}
