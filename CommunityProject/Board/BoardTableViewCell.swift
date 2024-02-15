//
//  BoardTableViewCell.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/29.
//

import UIKit
import SnapKit

class BoardTableViewCell: UITableViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.tintColor = .black
        view.layer.cornerRadius = 25
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let profileImageButton = {
        let view = UIButton()
        view.tintColor = .clear
        
        return view
    }()
    
    let userLabel = {
        let view = UILabel()
        view.text = "아이디"
        view.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.text = "날짜"
        view.font = .systemFont(ofSize: 15)
        
        return view
    }()
    
    let foodImage = {
        let view = UIImageView()
        view.image = UIImage(named: "br2")
        //view.contentMode = .scaleAspectFit

        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        
        return view
    }()
    
//    let hashtagLabel = {
//        let view = UILabel()
//        view.font = .systemFont(ofSize: 15)
//        
//        return view
//    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    let commentButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        view.tintColor = .black
        
        return view
    }()
    
    let moreCommentButton = {
        let view = UIButton()
        view.setTitle("hello", for: .normal)
        view.tintColor = .clear
        
        return view
    }()
    
    let moreCommentLabel = {
        let view = UILabel()
        view.text = "view 5 comments"
        view.textColor = .lightGray
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        self.isUserInteractionEnabled = true
        
        for item in [profileImage, profileImageButton, userLabel, dateLabel, foodImage, titleLabel, contentLabel, likeButton, commentButton, moreCommentButton, moreCommentLabel] {
            contentView.addSubview(item)
        }
    }
    
    func setConstraints() {
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        profileImageButton.snp.makeConstraints { make in
            make.edges.equalTo(profileImage)
        }
        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(18)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(5)
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.height.equalTo(18)
        }
        foodImage.snp.makeConstraints { make in
            make.size.equalTo(UIScreen.main.bounds.width - 40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(foodImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
//        hashtagLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentLabel.snp.bottom).offset(7)
//            make.leading.equalToSuperview().inset(20)
//            make.height.equalTo(20)
//        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(7)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
            make.size.equalTo(24)
        }
        moreCommentButton.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(7)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        moreCommentLabel.snp.makeConstraints { make in
            make.edges.equalTo(moreCommentButton)
        }
    }
    
}
