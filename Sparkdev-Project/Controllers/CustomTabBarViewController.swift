//
//  CustomTabBarViewController.swift
//  Sparkdev-Project
//
//  Created by Jason Francis on 9/24/22.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor(named: "TabBarTint")!
        
        self.tabBar.layer.cornerRadius = 25
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.additionalSafeAreaInsets.bottom = 0
               
        self.selectedIndex = 2
    }
}
