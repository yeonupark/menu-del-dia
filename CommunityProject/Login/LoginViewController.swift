//
//  LoginViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/14.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    let mainView = LoginView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
        mainView.signUpButton.addTarget(self, action: #selector(joinButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BehaviorSubject(value: "")
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        BehaviorSubject(value: "")
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
    }
    
    @objc func joinButtonClicked() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func bind() {
        viewModel.email
            .bind(to: mainView.idField.rx.text)
            .disposed(by: disposeBag)
        viewModel.pw
            .bind(to: mainView.pwField.rx.text)
            .disposed(by: disposeBag)
        
        mainView.idField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        mainView.pwField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        viewModel.loginButtonEnabled
            .bind(to: mainView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.loginButtonColor
            .bind(to: mainView.loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        let loginInfo = Observable.combineLatest(viewModel.email, viewModel.pw) { first, second in
            return LoginModel(email: first, password: second)
        }
        
        mainView.loginButton
            .rx
            .tap
            .withLatestFrom(loginInfo)
            .subscribe(with: self) { owner, value in
                owner.viewModel.loginRequest(email: value.email, pw: value.password) { response in
                    if response == nil {
                        // alert
                        print("로그인 실패")
                    } else {
                        // alert
                        print("로그인 성공")
                        let vc = TabBarController()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
            
    }
}
