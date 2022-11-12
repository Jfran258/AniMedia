//
//  Article.swift
//  Sparkdev-Project
//
//  Created by Miguel Sablan on 11/11/22.
//

import UIKit

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
