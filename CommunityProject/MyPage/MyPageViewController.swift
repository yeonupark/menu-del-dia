//
//  MyPageViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/26.
//

import UIKit
import RxSwift

class MyPageViewController: UIViewController {
    
    let mainView = MyPageView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = MyPageViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    

    func bind() {
        mainView.fakeButton
            .rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.callWithdrawRequest { result in
                    if result == 200 {
                        let vc = LoginViewController()
                        owner.navigationController?.setViewControllers([vc], animated: true)
                        
                    } else if result == 419 {
                        owner.viewModel.callRefreshToken { value in
                            if value {
                                // 토큰 리프레쉬 성공. 탈퇴요청 다시
                                owner.viewModel.callWithdrawRequest { _ in
                                    let vc = LoginViewController()
                                    owner.navigationController?.setViewControllers([vc], animated: true)
                                }
                            } else {
                                // 토큰 리프레쉬 실패. 첫화면으로 돌아가서 다시 로그인 해야됨
                                // alert
                                let vc = LoginViewController()
                                owner.navigationController?.setViewControllers([vc], animated: true)
                            }
                        }
                    } else {
                        print("error")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}
