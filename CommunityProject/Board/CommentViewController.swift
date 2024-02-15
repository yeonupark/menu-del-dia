//
//  CommentViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2024/02/15.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CommentViewController: UIViewController {

    let mainView = CommentView()
    
    let commentData = BehaviorRelay(value: [Comment?]())
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view.self = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        commentData
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "CommentTableViewCell", cellType: CommentTableViewCell.self)) { (row, element, cell) in
                
                cell.nickname.text = element?.creator.nick
                cell.content.text = element?.content
                
                guard let str = element?.time else {
                    return
                }
                
                let s = str.index(str.startIndex, offsetBy: 5)
                let e = str.index(str.startIndex, offsetBy: 9)
                let day = str[s...e]
                let start = str.index(str.startIndex, offsetBy: 11)
                let end = str.index(str.startIndex, offsetBy: 15)
                let time = str[start...end]
                
                cell.dateLabel.text = "\(day) \(time)"
                
                let modifier = AnyModifier { request in
                    var r = request
                    r.setValue(APIkey.sesacKey, forHTTPHeaderField: "SesacKey")
                    r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
                    
                    return r
                }
                
                if let profileUrl = element?.creator.profile {
                    guard let url = URL(string: "\(APIkey.baseURL)\(profileUrl)") else { return }
                    
                    cell.profileImage.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
}
