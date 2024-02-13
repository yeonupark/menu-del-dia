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
        
        viewModel.fetchPost(limit: "10", product_id: "tmm")
    }
    
    func bind() {
        viewModel.board
            .map { $0.data }
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "BoardTableViewCell", cellType: BoardTableViewCell.self)) { (row, element, cell) in
                cell.userLabel.text = element.creator.nick
                
                let str = element.time
                
                let s = str.index(str.startIndex, offsetBy: 5)
                let e = str.index(str.startIndex, offsetBy: 9)
                let day = str[s...e]
                let start = str.index(str.startIndex, offsetBy: 11)
                let end = str.index(str.startIndex, offsetBy: 15)
                let time = str[start...end]
                
                cell.dateLabel.text = "\(day) \(time)"
                cell.titleLabel.text = element.title
                cell.contentLabel.text = element.content
                cell.hashtagLabel.text = element.content1
                
                cell.likeButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.likeButtonClicked(element._id) { result in
                            if result {
                                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                                cell.likeButton.tintColor = .red
                                
                            } else {
                                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                                cell.likeButton.tintColor = .black
                            }
                        }
                    }
                    .disposed(by: self.disposeBag)
                cell.commentButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.postComment(id: element._id, content: "사진 예뻐요!")
                    }
                    .disposed(by: self.disposeBag)
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(APIkey.sesacKey, forHTTPHeaderField: "SesacKey")
                    r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
                    
                    return r
                }
                
                if let profileUrl = element.creator.profile {
                    guard let url = URL(string: "\(APIkey.baseURL)\(profileUrl)") else { return }
                    
                    cell.profileImage.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                    }
                }
                
                if element.image.isEmpty {
                    DispatchQueue.main.async {
                        cell.foodImage.image = UIImage(systemName: "nosign")
                    }
                } else {
                    guard let url = URL(string: "\(APIkey.baseURL)\(element.image[0])") else { return }
                
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

//extension BoardViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BoardTableViewCell", for: indexPath) as? BoardTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        return cell
//    }
//}
