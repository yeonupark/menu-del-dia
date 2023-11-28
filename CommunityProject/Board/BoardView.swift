//
//  HomeView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit

class BoardView: BaseView {
    
    let postButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        addSubview(postButton)
    }
    
    override func setConstraints() {
        
        postButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.size.equalTo(80)
        }
    }
}
