//
//  TabBarController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    func setTabBar() {
        
        let homeTab = HomeViewController()
        homeTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        
        let myPageTab = MyPageViewController()
        myPageTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 1)
        
        viewControllers = [homeTab, myPageTab]
        
        navigationController?.navigationItem.backBarButtonItem?.isHidden = true
    }
}
