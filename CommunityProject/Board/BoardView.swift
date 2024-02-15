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
        view.rowHeight = 150 + UIScreen.main.bounds.width
        
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
        view.backgroundColor = .white
        view.tintColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()
    
    let postLabel = {
        let view = UILabel()
        view.text = "* Post What You Ate Today *"
        view.backgroundColor = .white
        view.font = .boldSystemFont(ofSize: 13)
        
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
