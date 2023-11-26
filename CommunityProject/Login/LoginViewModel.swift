//
//  LoginViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/24.
//

import UIKit
import RxSwift
import Moya

class LoginViewModel {
    
    let email = BehaviorSubject(value: "")
    let pw = BehaviorSubject(value: "")
    
    let loginButtonEnabled = BehaviorSubject(value: false)
    let loginButtonColor = BehaviorSubject(value: UIColor.lightGray)
    
    let disposeBag = DisposeBag()
    
    init() {
        fieldCheck()
    }
    
    func fieldCheck() {
        let validation = Observable.combineLatest(email, pw) { first, second in
            if first.isEmpty || second.isEmpty {
                return false
            }
            return true
        }
        
        validation
            .subscribe(with: self) { owner, value in
                let color = value ? UIColor.systemBlue : UIColor.lightGray
                owner.loginButtonEnabled.onNext(value)
                owner.loginButtonColor.onNext(color)
            }
            .disposed(by: disposeBag)
    }
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func loginRequest(email: String, pw: String, completionHandler: @escaping (LoginResponse?) -> Void) {
        provider.request(.login(email: email, pw: pw)) { result in
            
            switch result {
            case .success(let response):
                print("success - ", response.statusCode, response.data)
        
                do {
                    let result = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                    print(result)
                    UserDefaults.standard.set(result.token, forKey: "token")
                    UserDefaults.standard.set(result.refreshToken, forKey: "refreshToken")
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
