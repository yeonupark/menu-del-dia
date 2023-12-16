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
    
    let viewModel = EditProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.getMyProfile { num in
            print(num)
        }
        setNavigationBar()
    }
    
    func setNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: nil)

        navigationItem.setRightBarButton(saveButton, animated: true)
        
        let myProfile = Observable.combineLatest(viewModel.profileUrl, viewModel.nickname, viewModel.phoneNumber, viewModel.birthday) { url, nick, phone, birthday in
            
            return MyProfileModel(nick: nick, phoneNum: phone, birthDay: birthday, profile: nil)
        }
        
        saveButton
            .rx
            .tap
            .withLatestFrom(myProfile)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, model in
                print("버튼 클릭")
                owner.viewModel.editMyProfile(myProfile: model) { statusCode in
                    if statusCode == 419 {
                        self.viewModel.callRefreshToken { value in
                            if value {
                                // 토큰 리프레쉬 성공. 탈퇴요청 다시
                                self.viewModel.getMyProfile { code in
                                    print("getMyProfile 재호출 결과 statusCode: \(code)")
                                }
                            } else {
                                // 토큰 리프레쉬 실패. 첫화면으로 돌아가서 다시 로그인 해야됨
                                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
                            }
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func bind() {
        
        viewModel.email
            .bind(to: mainView.idLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.nickname
            .bind(to: mainView.nickTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.phoneNumber
            .bind(to: mainView.phoneNumTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.birthday
            .bind(to: mainView.birthdayTextField.rx.text)
            .disposed(by: disposeBag)
        
        mainView.nickTextField
            .rx
            .text
            .orEmpty
            .subscribe(with: self) { owner, nickname in
                owner.viewModel.nickname.accept(nickname)
            }
            .disposed(by: disposeBag)
        mainView.phoneNumTextField
            .rx
            .text
            .orEmpty
            .subscribe(with: self) { owner, num in
                owner.viewModel.phoneNumber.accept(num)
            }
            .disposed(by: disposeBag)
        mainView.birthdayTextField
            .rx
            .text
            .orEmpty
            .subscribe(with: self) { owner, day in
                owner.viewModel.birthday.accept(day)
            }
            .disposed(by: disposeBag)
    }
}
