//
//  EditProfileViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import UIKit
import RxSwift

class EditProfileViewController: UIViewController {
    
    let mainView = EditProfileView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = MyPageViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
