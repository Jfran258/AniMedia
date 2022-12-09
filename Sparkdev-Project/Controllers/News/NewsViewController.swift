//
//  NewsViewController.swift
//  Sparkdev-Project
//
//  Created by Jean Elias on 11/7/22.
//

import UIKit
import SwiftSoup
import AlamofireImage
import SafariServices

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var data = [News]()
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        myRefreshControl.addTarget(self, action: #selector(redirectUrl), for: .valueChanged)
        myRefreshControl.tintColor = .white
        newsTableView.refreshControl = myRefreshControl
        
        redirectUrl()
    }
    
    @objc func redirectUrl() {
        let url = URL(string: "https://www.animenewsnetwork.com/news/anime")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let html = String(data: data!, encoding: .utf8) ?? "none"
            self.parse(html: html)
        }.resume()
    }
    
    func parse(html: String){
        do {
            let doc: Document = try SwiftSoup.parse(html)
            
            let mainFeed = try doc.select ("div.mainfeed-section")
            
            data.removeAll()
            
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
                
                // preview text
                let preview: String = try news.select("div.preview").text()
                
                let article = News(title: titleName, imageName: imgUrl, date: date, preview: preview, link: linkUrl)
                
                data.append(article)
            }
            
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = data[indexPath.row]
        
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        cell.title.text = article.title
        
        let imgUrl = URL(string: article.imageName)
        cell.iconImageView.af.setImage(withURL: imgUrl!)
        cell.iconImageView.layer.cornerRadius = 12
        
        //cell.date.text = article.date
        
        cell.previewLabel.text = article.preview
        
        cell.selectionStyle = .none
        
        cell.newsBodyView.layer.cornerRadius = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let program = data[indexPath.row]
        
        let redirect = program.link
        
        browser(url: redirect)
    }
    
    func browser(url: String){
        let url = URL(string: url)!
        
        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
}
