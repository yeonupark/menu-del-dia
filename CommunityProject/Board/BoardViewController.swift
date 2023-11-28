//
//  HomeViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit

class BoardViewController: UIViewController {
    
    let mainView = BoardView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = BoardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.postButton.addTarget(self, action: #selector(postButtonClicked), for: .touchUpInside)
        viewModel.fetchPost(limit: "5", product_id: "tmt") { response in
            //print(response)
        }
    }
    
    @objc func postButtonClicked() {
        let vc = PostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
