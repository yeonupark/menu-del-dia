//
//  SignUpViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/19.
//

import UIKit
import RxSwift

class SignUpViewModel {
    
    let email = BehaviorSubject(value: "")
    let pw = BehaviorSubject(value: "")
    let pwRepeat = BehaviorSubject(value: "")
    let nickname = BehaviorSubject(value: "")
    let phoneNumber = BehaviorSubject(value: "")
    let birthday = BehaviorSubject(value: "")
    
    let emailConfirmed = BehaviorSubject(value: false)
    //let pwConfirmed = BehaviorSubject(value: false)
    
    let joinButtonEnabled = BehaviorSubject(value: false)
    let joinButtonColor = BehaviorSubject(value: UIColor.lightGray)
    
    let disposeBag = DisposeBag()
    
    init() {
        fieldCheck()
    }
    
    func fieldCheck() {
        let validation = Observable.combineLatest(emailConfirmed, pw, pwRepeat, nickname) { first, second, third, fourth in
            if second.isEmpty || fourth.isEmpty {
                return false
            }
            return first && (second == third)
        }
        
        validation
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.systemBlue : UIColor.lightGray
                owner.joinButtonEnabled.onNext(value)
                owner.joinButtonColor.onNext(color)
            }
            .disposed(by: disposeBag)
    }
}
