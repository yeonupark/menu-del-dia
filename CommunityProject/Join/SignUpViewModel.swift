//
//  SignUpViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/19.
//

import UIKit
import RxSwift
import Moya

class SignUpViewModel {
    
    let email = BehaviorSubject(value: "")
    let pw = BehaviorSubject(value: "")
    let pwRepeat = BehaviorSubject(value: "")
    let nickname = BehaviorSubject(value: "")
    let phoneNumber = BehaviorSubject(value: "")
    let birthday = BehaviorSubject(value: "")
    
    let emailConfirmed = BehaviorSubject(value: true)
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
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func validateEmail(email: String) {
        provider.request(.emailValidation(email: email)) { result in
            switch result {
            case .success(let response):
                print("success - ", response.statusCode, response.data)
            
                do {
                    let result = try JSONDecoder().decode(EmailResponse.self, from: response.data)
                    print(result)
                } catch {
                    print("error")
                }
                
            case .failure(let error):
                print("error - ", error)
            }
        }
        
    }
    
    func signUpRequest(email: String, pw: String, nickname: String, completionHandler: @escaping (JoinResponse?) -> Void) {
        provider.request(.join(model: JoinModel(email: email, password: pw, nick: nickname))) { result in
            
            switch result {
            case .success(let response):
                print("success - ", response.statusCode, response.data)
        
                do {
                    let result = try JSONDecoder().decode(JoinResponse.self, from: response.data)
                    print(result)
                    completionHandler(result)
                } catch {
                    print("error")
                    completionHandler(nil)
                }
                
            case .failure(let error):
                print("error - ", error)
                completionHandler(nil)
            }
        
        }
    }
    
}
