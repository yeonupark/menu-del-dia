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
    let imageList = PublishSubject<[UIImage]>()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorization()
        
        bindCollectionView()
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
    
    func bindCollectionView() {
        imageList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "PostCollectionViewCell", cellType: PostCollectionViewCell.self)) { (row, element, cell) in
                
                cell.imageView.image = element
            }
            .disposed(by: disposeBag)
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
        
        let post = Observable.combineLatest(viewModel.title, viewModel.content, viewModel.hashTag, viewModel.imageData) { title, content, hashtag, images in
            return PostModel(title: title, content: content, file: images, product_id: "tmm", content1: hashtag, content2: nil)
        }
        
        mainView.postButton
            .rx
            .tap
            .withLatestFrom(post)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
                owner.viewModel.postRequest(postModel: data) { code, response in
                    print("뷰모델 imagedata: ", owner.viewModel.imageData.values)
                    
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

extension PostViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        var dataValue: [Data] = []
        var imageValue: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let image = image as? UIImage {
                        imageValue.append(image)
                        //guard let data = image.kf.data(format: .JPEG, compressionQuality: 0.5) else { return }
                        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                        dataValue.append(data)
                        
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            let combinedObservable = Observable.zip(Observable.just(dataValue), Observable.just(imageValue))
            
            combinedObservable
                .observe(on: MainScheduler.instance)
                .subscribe(with: self) { owner, value in
                    owner.viewModel.imageData.onNext(value.0)
                    owner.imageList.onNext(value.1)
                }
                .disposed(by: self.disposeBag)
            
            print(self.viewModel.imageData)
            print(self.viewModel.imageData.values)
        }
    }
}
