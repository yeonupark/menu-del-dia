//
//  SettingView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import UIKit
import SnapKit

class SettingView: BaseView {
    
    let tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //view.backgroundColor = .white
        view.rowHeight = 50
        
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(tableView)
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaInsets)
        }
    }
}


