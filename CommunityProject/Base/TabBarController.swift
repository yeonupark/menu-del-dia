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
        
        let boardTab = UINavigationController(rootViewController: BoardViewController())
        boardTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)
        
        let myPageTab = UINavigationController(rootViewController: MyPageViewController())
        myPageTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 1)
        
        viewControllers = [boardTab, myPageTab]
        
        //navigationController?.navigationItem.backBarButtonItem?.isHidden = true
    }
}
