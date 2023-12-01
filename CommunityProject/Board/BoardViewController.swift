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
        
        setNavigationBar()
        
        mainView.postButton.addTarget(self, action: #selector(postButtonClicked), for: .touchUpInside)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        
    }
    
    func fetch() {
//        viewModel.board
//            .bind(to: <#T##GetPostResponse...##GetPostResponse#>)
        viewModel.fetchPost(limit: "5", product_id: "tmt") { response in
        }
    }
    func setNavigationBar() {
        navigationItem.hidesBackButton = true
        let myPageButton = UIBarButtonItem(title: "MY", style: .plain, target: self, action: #selector(myPageButtonClicked))
        
        navigationItem.setRightBarButton(myPageButton, animated: true)
    }
    
    @objc func myPageButtonClicked() {
        let vc = MyPageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func postButtonClicked() {
        let vc = PostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as? BoardTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}
