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
    
    let emailConfirmed = BehaviorSubject(value: false)
    let emailValidationText = BehaviorSubject(value: "Please verify your email address")
    let emailValidationColor = BehaviorSubject(value: UIColor.black)
    
    let joinButtonEnabled = BehaviorSubject(value: false)
    let joinButtonColor = BehaviorSubject(value: UIColor.lightGray)
    
    let disposeBag = DisposeBag()
    
    init() {
        //emailCheck()
        fieldCheck()
    }
    
    func emailCheck() {
        emailConfirmed
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.blue : UIColor.red
                let text = value ? "Your email has been verified" : "The email address is unavailable"
                owner.emailValidationColor.onNext(color)
                owner.emailValidationText.onNext(text)
            }
            .disposed(by: disposeBag)
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
    
    func validateEmail(email: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.emailValidation(email: email)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("emailvalidation success - ", response.statusCode, response.data)
                    
                    completionHandler(true)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("emailvalidation failure - ", response.statusCode, response.data)
                    
//                    do {
//                        let result = try JSONDecoder().decode(EmailResponse.self, from: response.data)
//                    } catch {
//                        print("signup error")
//                    }
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("emailvalidation error - ", error)
                completionHandler(false)
            }
        }
        
    }
    
    func signUpRequest(email: String, pw: String, nickname: String, phoneNumber: String?, birthDay: String?, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.join(model: JoinModel(email: email, password: pw, nick: nickname, phoneNum: phoneNumber, birthday: birthDay))) { result in
            
            switch result {
            case .success(let response):
                print("signup success - ", response.statusCode, response.data)
        
                do {
                    let result = try JSONDecoder().decode(JoinResponse.self, from: response.data)
                    print(result)
                    completionHandler(true)
                } catch {
                    print("signup error")
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("signup error - ", error)
                completionHandler(false)
            }
        
        }
    }
    
}
