//
//  SignUpView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/18.
//

import UIKit
import SnapKit

class SignUpView: BaseView {
    
    let emailField = {
        let view = UITextField()
        view.placeholder = "email"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let emailValidationButton = {
        let view = UIButton()
        view.setTitle("confirm", for: .normal)
        view.layer.cornerRadius = 5
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        view.backgroundColor = .black
        
        return view
    }()
    
    let pwField = {
        let view = UITextField()
        view.placeholder = "password"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let pwRepeatField = {
        let view = UITextField()
        view.placeholder = "password again"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let nickField = {
        let view = UITextField()
        view.placeholder = "nickname"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let phoneNumberField = {
        let view = UITextField()
        view.placeholder = "phone number"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let birthdayField = {
        let view = UITextField()
        view.placeholder = "birthday"
        view.borderStyle = .roundedRect
        
        return view
    }()
    
    let joinButton = {
        let view = UIButton()
        view.setTitle("JOIN", for: .normal)
        view.layer.cornerRadius = 5
        view.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        view.backgroundColor = .black
        
        return view
        
    }()
    
    override func configure() {
        super.configure()
        
        for item in [emailField, emailValidationButton, pwField, pwRepeatField, nickField, phoneNumberField, birthdayField, joinButton] {
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        
        emailField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(200)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        emailValidationButton.snp.makeConstraints { make in
            make.leading.equalTo(emailField.snp.trailing).offset(10)
            make.verticalEdges.equalTo(emailField)
            make.trailing.equalToSuperview().inset(50)
        }
        
        let fieldList = [emailField, pwField, pwRepeatField, nickField, phoneNumberField, birthdayField]
        
        for i in (1...fieldList.count-1) {
            
            fieldList[i].snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(50)
                make.top.equalTo(fieldList[i-1].snp.bottom).offset(10)
                make.height.equalTo(50)
                
            }
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(birthdayField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
    }
}
