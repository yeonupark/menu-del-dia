//
//  MyPageView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit
import SnapKit

class MyPageView: BaseView {
    
    let fakeButton = {
        let view = UIButton()
        
        view.setTitle("탈퇴", for: .normal)
        view.backgroundColor = .green
        return view
    }()
    
    override func configure() {
        super.configure()
        addSubview(fakeButton)
    }
    
    override func setConstraints() {
        fakeButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}
