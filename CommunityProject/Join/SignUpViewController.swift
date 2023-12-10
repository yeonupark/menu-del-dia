//
//  SignUpViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    let mainView = SignUpView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = SignUpViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.emailValidationButton.addTarget(self, action: #selector(emailValidationButtonClicked), for: .touchUpInside)
        
        bind()
    }
    
    @objc func emailValidationButtonClicked() {
       
    }
    
    func bind() {
        
        viewModel.email
            .bind(to: mainView.emailField.rx.text)
            .disposed(by: disposeBag)
        viewModel.pw
            .bind(to: mainView.pwField.rx.text)
            .disposed(by: disposeBag)
        viewModel.pwRepeat
            .bind(to: mainView.pwRepeatField.rx.text)
            .disposed(by: disposeBag)
        viewModel.nickname
            .bind(to: mainView.nickField.rx.text)
            .disposed(by: disposeBag)
        viewModel.phoneNumber
            .bind(to: mainView.phoneNumberField.rx.text)
            .disposed(by: disposeBag)
        viewModel.birthday
            .bind(to: mainView.birthdayField.rx.text)
            .disposed(by: disposeBag)
        viewModel.emailValidationText
            .bind(to: mainView.emailValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        mainView.emailField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        mainView.emailValidationButton
            .rx
            .tap
            .withLatestFrom(viewModel.email)
            .subscribe(with: self, onNext: { owner, email in
                owner.viewModel.validateEmail(email: email, completionHandler: { result in
                    owner.viewModel.emailConfirmed.onNext(result)
                })
                owner.viewModel.emailCheck()
                
            })
            .disposed(by: disposeBag)
        
        mainView.pwField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.pw)
            .disposed(by: disposeBag)
        
        mainView.pwRepeatField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.pwRepeat)
            .disposed(by: disposeBag)
        
        mainView.nickField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        mainView.phoneNumberField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        mainView.birthdayField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        viewModel.joinButtonEnabled
            .bind(to: mainView.joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.joinButtonColor
            .bind(to: mainView.joinButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.emailValidationText
            .bind(to: mainView.emailValidationLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.emailValidationColor
            .bind(to: mainView.emailValidationLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        let join = Observable.combineLatest(viewModel.email, viewModel.pw, viewModel.nickname, viewModel.phoneNumber, viewModel.birthday) { email, pw, nick, pn, birthday in
            return JoinModel(email: email, password: pw, nick: nick, phoneNum: pn, birthday: birthday)
        }
        
        mainView.joinButton
            .rx
            .tap
            .withLatestFrom(join)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.viewModel.signUpRequest(email: value.email, pw: value.password, nickname: value.nick, phoneNumber: value.phoneNum, birthDay: value.birthday) { response in
                    if response {
                        // alert
                        owner.navigationController?.popViewController(animated: true)
                    } else {
                        // alert
                        
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

#Preview {
    SignUpViewController()
}
