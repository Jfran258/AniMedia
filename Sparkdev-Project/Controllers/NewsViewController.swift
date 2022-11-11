//
//  NewsViewController.swift
//  Sparkdev-Project
//
//  Created by Jean Elias on 11/7/22.
//

import UIKit
import SwiftSoup
import AlamofireImage

class NewsViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var table:UITableView!
    
    struct News {
        let title: String
        let imageName: String
        let date: String
        let link: String
        
        init(title: String, imageName: String, date: String, link: String){
            self.title = title
            self.imageName = imageName
            self.date = date
            self.link = link
        }
    }
    
    
    var data = [News]()


    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
        getNews()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let imgUrl = URL(string: article.imageName)
        
        cell.title.text = article.title
        cell.iconImageView.af.setImage(withURL: imgUrl!)
        cell.date.text = article.date
        
        
        
        return cell
    }
    
    func getNews( ){
        do {
            let content = try String(contentsOf: URL(string: "https://www.animenewsnetwork.com/news/")!)
            let doc: Document = try SwiftSoup.parse(content)
            let mainFeed = try doc.select ("div.mainfeed-section")
            let mF = try mainFeed.toString()
            
            for news: Element in try mainFeed.select("div.herald") {
                //title
                let title: Elements = try news.select("h3")
                let titleName: String = try title.text()
                //link
                let link: Element = try title.select("a").first()!
                let linkHref: String = try link.attr("href")
                let linkUrl: String = "https://www.animenewsnetwork.com" + linkHref
                //image
                let imageName: Elements = try news.select("div.thumbnail")
                let imgLink: String = try imageName.attr("data-src")
                let imgUrl: String = "https://www.animenewsnetwork.com" + imgLink
                
                //date
                let date: String = try news.select("time").text()
                
                
                var article = News(title: titleName, imageName: imgUrl, date: date, link: linkUrl)
                
                data.append(article)
                
                print (article)
                
                

             /*  if  == ("herald box news"){
                    let title: String = try doc.select("h3").text()*/
        
            }
            
          
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
  
    
    
    

}
