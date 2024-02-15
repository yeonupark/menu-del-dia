//
//  CommentView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2024/02/15.
//

import UIKit
import SnapKit

class CommentView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        view.backgroundColor = .clear
        view.rowHeight = 70
        
        return view
    }()
    
    let comment = {
        let view = UILabel()
        view.text = "테스트"
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
