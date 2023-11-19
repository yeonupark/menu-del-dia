//
//  BaseView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/18.
//

import Foundation
import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        
    }
    
}
