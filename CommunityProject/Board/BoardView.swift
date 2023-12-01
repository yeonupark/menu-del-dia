//
//  HomeView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit

class BoardView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(BoardTableViewCell.self, forCellReuseIdentifier: "BoardTableViewCell")
        view.backgroundColor = .clear
        view.rowHeight = 100 + UIScreen.main.bounds.width
        
        return view
    }()
    
    let postImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "camera.circle")
        view.tintColor = .black
        
        return view
    }()
    
    let postButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        view.tintColor = .clear
        return view
    }()
    
    let postLabel = {
        let view = UILabel()
        view.text = "Post What You Ate Today"
        view.font = .boldSystemFont(ofSize: 14)
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(tableView)
        addSubview(postButton)
        addSubview(postImage)
        addSubview(postLabel)
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        postButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(64)
            make.size.equalTo(70)
        }
        postImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(64)
            make.size.equalTo(70)
        }
        postLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(postImage.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
    }
}
