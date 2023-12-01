//
//  PostViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/27.
//

import UIKit
import RxSwift

class PostViewController: UIViewController {
    
    let mainView = PostView()
    
    override func loadView() {
        view.self = mainView
    }
    
    let viewModel = PostViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
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
        
        let post = Observable.combineLatest(viewModel.title, viewModel.content, viewModel.hashTag) { title, content, hashtag in
            return PostModel(title: title, content: content, file: nil, product_id: "tmm", content1: hashtag, content2: nil)
        }
        
        mainView.postButton
            .rx
            .tap
            .withLatestFrom(post)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                owner.viewModel.postRequest(postModel: value) { response in
                    if response == nil {
                        // alert
                    } else {
                        // alert
                        owner.navigationController?.popViewController(animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}
