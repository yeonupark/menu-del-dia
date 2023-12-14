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
        view.image = UIImage(systemName: "person.circle")
        view.tintColor = .black
        
        return view
    }()
    
    let editImageButton = {
        let view = UIButton()
        view.setTitle("Edit picture", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.systemBlue, for: .normal)
        
        return view
    }()
    
    let idLabel = {
        let view = UILabel()
        view.text = "idepix@naver.com"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let nickTextField = {
        let view = UITextField()
        view.text = "nickname"
        view.font = .boldSystemFont(ofSize: 15)
        view.borderStyle = .bezel
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let phoneNumTextField = {
        let view = UITextField()
        view.text = "01012341234"
        view.font = .boldSystemFont(ofSize: 15)
        view.borderStyle = .bezel
        view.layer.borderColor = UIColor.gray.cgColor
        
        return view
    }()
    
    let birthdayTextField = {
        let view = UITextField()
        view.text = "2023/12/14"
        view.font = .boldSystemFont(ofSize: 15)
        view.borderStyle = .bezel
        view.layer.borderColor = UIColor.gray.cgColor
        
        return view
    }()
    
    func constantLabel(text: String) -> UILabel {
        let view = UILabel()
        view.text = text
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }
    
    let idConstantLabel = {
        let view = UILabel()
        view.text = "email"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let nickConstantLabel = {
        let view = UILabel()
        view.text = "nickname"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let phoneConstantLabel = {
        let view = UILabel()
        view.text = "phone number"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    
    let birthdayConstantLabel = {
        let view = UILabel()
        view.text = "birthday"
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    
    override func configure() {
        super.configure()
        
        for item in [profileImage, editImageButton, idConstantLabel, nickConstantLabel, phoneConstantLabel, birthdayConstantLabel, idLabel, nickTextField, phoneNumTextField, birthdayTextField] {
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.size.equalTo(80)
        }
        editImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(6)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        let arr2 = [editImageButton, idConstantLabel, nickConstantLabel, phoneConstantLabel, birthdayConstantLabel]
        for i in (1...arr2.count-1) {
            arr2[i].snp.makeConstraints { make in
                make.top.equalTo(arr2[i-1].snp.bottom).offset(6)
                make.height.equalTo(20)
                make.width.equalTo(120)
                make.leading.equalToSuperview().inset(40)
            }
        }
        
        let arr = [editImageButton, idLabel, nickTextField, phoneNumTextField, birthdayTextField]
        for i in (1...arr.count-1) {
            arr[i].snp.makeConstraints { make in
                make.top.equalTo(arr[i-1].snp.bottom).offset(6)
                make.height.equalTo(20)
                make.leading.equalTo(arr2[i].snp.trailing).offset(20)
                make.trailing.equalToSuperview().inset(40)
            }
        }
    }
    
}
