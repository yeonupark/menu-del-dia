//
//  PostViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import Photos
import PhotosUI

class PostViewController: UIViewController {
    
    let mainView = PostView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = PostViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
        
        bind()
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
        configuration.selectionLimit = 50
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func bind() {
        viewModel.title
            .bind(to: mainView.titleField.rx.text)
            .disposed(by: disposeBag)
        viewModel.content
            .bind(to: mainView.contentField.rx.text)
            .disposed(by: disposeBag)
        viewModel.hashTag
            .bind(to: mainView.hashtagField.rx.text)
            .disposed(by: disposeBag)
        
        mainView.titleField
            .rx
            .text
            .orEmpty
            .subscribe(with: self) { owner, value in
                owner.viewModel.title.onNext(value)
            }
            .disposed(by: disposeBag)
        mainView.contentField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.content)
            .disposed(by: disposeBag)
        mainView.hashtagField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.hashTag)
            .disposed(by: disposeBag)
        
        let post = Observable.combineLatest(viewModel.title, viewModel.content, viewModel.hashTag, viewModel.images) { title, content, hashtag, images in
            return PostModel(title: title, content: content, file: images, product_id: "tmm", content1: hashtag, content2: nil)
        }
        
        mainView.postButton
            .rx
            .tap
            .withLatestFrom(post)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
                owner.viewModel.postRequest(postModel: data) { code, response in
                    print("뷰모델 images: ", owner.viewModel.images)
                    
                    if code == 200 {
                        owner.navigationController?.popViewController(animated: true)
                    } else if code == 419 {
                        self.viewModel.callRefreshToken { value in
                            if value {
                                // 토큰 리프레쉬 성공. post 요청
                                self.viewModel.postRequest(postModel: data) { _, _ in
                                    owner.navigationController?.popViewController(animated: true)
                                }
                            } else {
                                // 토큰 리프레쉬 실패. 첫화면으로 돌아가서 다시 로그인 해야됨
                                // alert
                                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
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

