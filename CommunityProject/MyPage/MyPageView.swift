//
//  MyPageView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit
import SnapKit

class MyPageView: BaseView {
    
    let profileImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.image = UIImage(systemName: "person.circle")
        view.tintColor = .black
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let nicknameLabel = {
        let view = UILabel()
        view.text = "닉네임"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let editProfileButton = {
        let view = UIButton()
        view.setTitle("Edit profile", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.systemBlue, for: .normal)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let postButton = {
        let view = UIButton()
        view.tintColor = .clear
        
        return view
    }()
    
    let followerButton = {
        let view = UIButton()
        view.tintColor = .clear
        
        return view
    }()
    
    let followingButton = {
        let view = UIButton()
        view.tintColor = .clear
        
        return view
    }()
    
    let postNumberLabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .boldSystemFont(ofSize: 20)
        
        return view
    }()
    
    let postLabel = {
        let view = UILabel()
        view.text = "Posts"
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    let followerNumberLabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .boldSystemFont(ofSize: 20)
        
        return view
    }()
    
    let followerLabel = {
        let view = UILabel()
        view.text = "Followers"
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    let followingNumberLabel = {
        let view = UILabel()
        view.text = "0"
        view.font = .boldSystemFont(ofSize: 20)
        
        return view
    }()
    
    let followingLabel = {
        let view = UILabel()
        view.text = "Following"
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    lazy var collectionView = {
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.isScrollEnabled = true
        view.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        return view
    }()
        
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let size = UIScreen.main.bounds.width - 92
        layout.itemSize = CGSize(width: size/3, height: size/3)
        return layout
    }
    
    
    override func configure() {
        super.configure()
        
        for item in [profileImage, nicknameLabel, editProfileButton, postButton, followerButton, followingButton, collectionView] {
            addSubview(item)
        }
        
        for item in [postNumberLabel, postLabel] {
            postButton.addSubview(item)
        }
        for item in [followerNumberLabel, followerLabel] {
            followerButton.addSubview(item)
        }
        for item in [followingNumberLabel, followingLabel] {
            followingButton.addSubview(item)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(80)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(6)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
        }
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
        }
        postButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom)
            make.leading.equalToSuperview()
            make.size.equalTo(UIScreen.main.bounds.width/3)
        }
        followerButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom)
            make.leading.equalTo(postButton.snp.trailing)
            make.size.equalTo(UIScreen.main.bounds.width/3)
        }
        followingButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom)
            make.leading.equalTo(followerButton.snp.trailing)
            make.size.equalTo(UIScreen.main.bounds.width/3)
        }
        postNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        postLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(postNumberLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        followerNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        followerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(followerNumberLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        followingNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        followingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(followingNumberLabel.snp.bottom).offset(4)
            make.height.equalTo(15)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(postButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
}
