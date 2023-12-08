//
//  PostCollectionViewCell.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/07.
//

import UIKit
import SnapKit

class PostCollectionViewCell: UICollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(imageView)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

