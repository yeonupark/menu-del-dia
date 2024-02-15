//
//  PostView.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/27.
//

import UIKit

class PostView: BaseView {
    
    let titleField = {
        let view = UITextField()
        view.placeholder = " write a title"
        
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "newGray")
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
    
    let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo.on.rectangle.angled")
        return view
    }()
    
//    lazy var collectionView = {
//        
//        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
//        view.isScrollEnabled = true
//        view.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
//        return view
//    }()
//    
//    private func collectionViewLayout() -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 8
//        let size = UIScreen.main.bounds.width - 32
//        layout.itemSize = CGSize(width: size/3, height: size/2.5)
//        return layout
//    }
    
    let contentField = {
        let view = UITextView()
        view.isEditable = true
        view.font = .systemFont(ofSize: 16)
        
        view.layer.cornerRadius = 5
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor(named: "newGray")
        
        return view
    }()
    
//    let hashtagField = {
//        let view = UITextView()
//        view.isEditable = true
//        view.font = .systemFont(ofSize: 16)
//        view.layer.cornerRadius = 5
//        view.layer.borderWidth = 2
//        view.layer.borderColor = UIColor.black.cgColor
//        
//        return view
//    }()
    
    let postButton = {
        let view = UIButton()
        view.setTitle("* post *", for: .normal)
        view.setTitleColor(.white, for: .highlighted)
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    override func configure() {
        super.configure()
        
        for item in [titleField, imageView, contentField, postButton] {
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        
        titleField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(titleField)
            make.height.equalTo(350)
        }
        contentField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(titleField)
            make.height.equalTo(100)
        }
//        hashtagField.snp.makeConstraints { make in
//            make.top.equalTo(contentField.snp.bottom).offset(4)
//            make.horizontalEdges.equalTo(titleField)
//            make.height.equalTo(100)
//        }
        postButton.snp.makeConstraints { make in
            make.top.equalTo(contentField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
    }
}
