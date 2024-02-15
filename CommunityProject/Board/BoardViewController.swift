//
//  HomeViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit
import RxSwift
import Kingfisher
import FloatingPanel
import Toast

class BoardViewController: UIViewController, FloatingPanelControllerDelegate {
    
    var fpc: FloatingPanelController!
    
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
                //cell.hashtagLabel.text = element.content1
                cell.moreCommentLabel.text = "view \(element.comments.count) comments"
                
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
                        owner.makeComment(id: element._id)
                    }
                    .disposed(by: self.disposeBag)
                
                cell.moreCommentButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, _ in
                        owner.setFPC(commentData: element.comments)
                    }
                    .disposed(by: self.disposeBag)
                
                cell.profileImageButton.rx.tap
                    .observe(on: MainScheduler.instance)
                    .subscribe(with: self) { owner, _ in
                        owner.viewModel.follow(element.creator._id) { result in
                            if result {
                                owner.mainView.makeToast("\(element.creator.nick)님을 팔로우합니다.", position: .top)
                            } else {
                                owner.viewModel.unfollow(element.creator._id) { unfollowResult in
                                    if unfollowResult {
                                        owner.mainView.makeToast("\(element.creator.nick)님을 언팔로우합니다.", position: .top)
                                    }
                                }
                            }
                        }
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
    
    func makeComment(id: String) {
        let alert = UIAlertController(title: "댓글을 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "코멘트 입력"
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { action in
            if let tf = alert.textFields?.first {
                self.viewModel.postComment(id: id, content: tf.text ?? "맛있겠다 ㅠㅠ")
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func setFPC(commentData: [Comment?]) {
        let vc = CommentViewController()
        vc.commentData.accept(commentData)
        
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        fpc.set(contentViewController: vc)
        fpc.isRemovalInteractionEnabled = true
        fpc.changePanelStyle()
        
        self.present(fpc, animated: true, completion: nil)
    }
    
    func setNavigationBar() {
        navigationItem.hidesBackButton = true
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(myPageButtonClicked))
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

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0

        surfaceView.grabberHandle.isHidden = true
        surfaceView.appearance = appearance

    }
}
