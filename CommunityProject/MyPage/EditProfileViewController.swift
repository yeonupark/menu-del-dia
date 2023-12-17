//
//  EditProfileViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class EditProfileViewController: UIViewController {
    
    let mainView = EditProfileView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = EditProfileViewModel()
    let disposeBag = DisposeBag()
    
    let profileImage = BehaviorRelay(value: UIImage(systemName: "person.circle"))
    
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
        
        let myProfile = Observable.combineLatest(viewModel.profileData, viewModel.nickname, viewModel.phoneNumber, viewModel.birthday) { data, nick, phone, birthday in
            
            return MyProfileModel(nick: nick, phoneNum: phone, birthDay: birthday, profile: data)
        }
        
        saveButton
            .rx
            .tap
            .withLatestFrom(myProfile)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, model in
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
        
        profileImage
            .bind(to: mainView.profileImage.rx.image)
            .disposed(by: disposeBag)
        
        mainView.editImageButton
            .rx
            .tap
            .subscribe(with: self) { owner, _ in
                self.checkAuthorization()
            }
            .disposed(by: disposeBag)
    }
    
    func checkAuthorization() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized {
            showImagePicker()
        } else if status == .denied || status == .restricted {
            showDeniedAlert()
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.showImagePicker()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showDeniedAlert()
                    }
                }
            }
        }
        
    }
    
    func showDeniedAlert() {
        let alert = UIAlertController(title: "갤러리에 접근할 수 없습니다.", message: "기기의 '설정>개인정보 보호'에서 갤러리 접근 권한을 허용해주세요.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let goToSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting)
            }
        }
        alert.addAction(cancel)
        alert.addAction(goToSetting)
        present(alert, animated: true)
    }
    
    func showImagePicker() {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        present(picker, animated: true)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            return
        }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                
                if let image = image as? UIImage {
                    
                    self.profileImage.accept(image)
                    
                    guard let data = image.kf.data(format: .JPEG, compressionQuality: 0.1) else { return }
                    self.viewModel.profileData.accept(data)
                    
                }
                
            }
            
        }
    }
}
