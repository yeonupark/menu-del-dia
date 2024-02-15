//
//  CommentTableViewCell.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2024/02/15.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {
    
    let profileImage = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let nickname = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let content = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        
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
        contentView.addSubview(profileImage)
        contentView.addSubview(nickname)
        contentView.addSubview(dateLabel)
        contentView.addSubview(content)
    }
    
    func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(nickname.snp.trailing).offset(8)
            make.height.equalTo(20)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(8)
            make.leading.equalTo(nickname)
        }
    }
}

