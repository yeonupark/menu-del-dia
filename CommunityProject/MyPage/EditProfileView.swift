//
//  EditProfileView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import UIKit

class EditProfileView: BaseView {
    
    let profileImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 40
        view.backgroundColor = .orange
        
        return view
    }()
    
    let editImageButton = {
        let view = UIButton()
        view.setTitle("Edit image", for: .normal)
        view.titleLabel?.textColor = .blue
        view.titleLabel?.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    // 닉네임
    // 아이디
    // 생일
    // 전화번호
}
