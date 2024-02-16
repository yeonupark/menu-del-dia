//
//  UserProfileViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2024/02/16.
//

import UIKit
import RxSwift
import Kingfisher

class UserProfileViewController: UIViewController {

    let mainView = MyPageView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = UserViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFollowButton()
        bind()
        fetchUserData()
        bindCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        fetchUserData()
        viewModel.fetchUserPost(limit: "10", product_id: "tmm")
    }
    
    func fetchUserData() {
        viewModel.getUserProfile { statusCode in
            if statusCode == 419 {
                self.viewModel.callRefreshToken { value in
                    if value {
                        // 토큰 리프레쉬 성공. 탈퇴요청 다시
                        self.viewModel.getUserProfile { code in
                            print("getMyProfile 재호출 결과 statusCode: \(code)")
                        }
                    } else {
                        // 토큰 리프레쉬 실패. 첫화면으로 돌아가서 다시 로그인 해야됨
                        self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                    }
                }
            }
        }
    }
    
    func bindCollectionView() {
        viewModel.userPostList
            .map { $0.data }
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "PostCollectionViewCell", cellType: PostCollectionViewCell.self)) { (row, element, cell) in
                let postImageString = element.image[0]
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(APIkey.sesacKey, forHTTPHeaderField: "SesacKey")
                    r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
                    
                    return r
                }
                
                let postImageUrl = element.image[0]
                guard let url = URL(string: "\(APIkey.baseURL)\(postImageUrl)") else { return }
                cell.imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        viewModel.profileUrl
            .map { "\(APIkey.baseURL)\($0)" }
            .subscribe(with: self) { owner, urlString in
                print("urlString", urlString)
                guard let url = URL(string: urlString) else { return }
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(APIkey.sesacKey, forHTTPHeaderField: "SesacKey")
                    r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
                    
                    return r
                }
                owner.mainView.profileImage.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                    switch result {
                    case .success(_):
                        return
                    case .failure(_):
                        print("이미지 로딩 실패")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .bind(to: mainView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.post
            .map { "\($0)" }
            .bind(to: mainView.postNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.follower
            .map { "\($0)" }
            .bind(to: mainView.followerNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.following
            .map { "\($0)" }
            .bind(to: mainView.followingNumberLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setFollowButton() {
        mainView.editProfileButton.setTitle("  * follow * ", for: .normal)
        mainView.editProfileButton.backgroundColor = .systemBlue
        mainView.editProfileButton.setTitleColor(.white, for: .normal)
        
        mainView.editProfileButton.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.follow(owner.viewModel.userID) { result in
                    if result {
                        owner.mainView.makeToast("\(owner.mainView.nicknameLabel.text ?? "")님을 팔로우합니다.", position: .top)
                    } else {
                        owner.viewModel.unfollow(owner.viewModel.userID) { unfollowResult in
                            if unfollowResult {
                                owner.mainView.makeToast("\(owner.mainView.nicknameLabel.text ?? "")님을 언팔로우합니다.", position: .top)
                            }
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
