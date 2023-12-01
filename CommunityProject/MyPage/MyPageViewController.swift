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
            .subscribe(with: self) { owner, _ in
                owner.viewModel.callWithdrawRequest { result in
                    if result == 200 {
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    } else if result == 419 {
                        owner.viewModel.callRefreshToken { value in
                            if value {
                                // 탈퇴요청 다시
                                owner.viewModel.callWithdrawRequest { result in
                                    if result == 200 {
                                        let vc = LoginViewController()
                                        vc.modalPresentationStyle = .fullScreen
                                        owner.present(vc, animated: true)
                                    }
                                }
                            } else {
                                // 첫화면으로 돌아가기
                                // alert
                                let vc = LoginViewController()
                                vc.modalPresentationStyle = .fullScreen
                                owner.present(vc, animated: true)
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
