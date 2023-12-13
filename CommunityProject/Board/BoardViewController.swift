//
//  HomeViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit
import RxSwift
import Kingfisher

class BoardViewController: UIViewController {
    
    let mainView = BoardView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = BoardViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.postButton.addTarget(self, action: #selector(postButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchPost(limit: "10", product_id: "")
    }
    
    func bind() {
        viewModel.board
            .map { $0.data }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "BoardTableViewCell", cellType: BoardTableViewCell.self)) { (row, element, cell) in
                cell.userLabel.text = element.creator.nick
                cell.dateLabel.text = element.time
                cell.titleLabel.text = element.title
                cell.contentLabel.text = element.content
                cell.hashtagLabel.text = element.content1
                
                if element.image.isEmpty {
                    DispatchQueue.main.async {
                        cell.foodImage.image = UIImage(systemName: "star")
                    }
                } else {
                    guard let url = URL(string: "\(APIkey.baseURL)\(element.image[0])") else { return }
                    
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue(APIkey.sesacKey, forHTTPHeaderField: "SesacKey")
                        r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
                        
                        return r
                    }
                    cell.foodImage.kf.setImage(with: url, placeholder: UIImage(systemName: "heart"), options: [.requestModifier(modifier)]) { result in
                        switch result {
                        case .success(_):
                            return
                        case .failure(_):
                            print("이미지 로딩 실패")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setNavigationBar() {
        navigationItem.hidesBackButton = true
        let myPageButton = UIBarButtonItem(title: "MY", style: .plain, target: self, action: #selector(myPageButtonClicked))
        myPageButton.tintColor = .black
        
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
