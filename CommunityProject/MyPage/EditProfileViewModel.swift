//
//  EditProfileViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class EditProfileViewModel: BaseViewModel {
    let email = PublishRelay<String>()
    let profileUrl = PublishRelay<String>()// = PublishRelay<String>()

    let nickname = BehaviorRelay(value: "ㅇㅇ") //= PublishRelay<String>()
    let phoneNumber = BehaviorRelay(value: "ㅇㅇ")// = PublishRelay<String>()
    let birthday = BehaviorRelay(value: "ㅇㅇ") // = PublishRelay<String>()
    
    let profileData = BehaviorRelay(value: Data())
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func getMyProfile(completionHandler: @escaping (Int) -> Void) {
        
        provider.request(.getMyProfile) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(MyProfileResponse.self, from: response.data)
                        
                        if let profile = result.profile {
                            self.profileUrl.accept(profile)
                        }
                        
                        self.email.accept(result.email)
                        self.nickname.accept(result.nick)
                        
                        if let phoneNumber = result.phoneNum {
                            self.phoneNumber.accept(phoneNumber)
                        }
                        if let birthday = result.birthDay {
                            self.birthday.accept(birthday)
                        }
                        
                        completionHandler(200)
                        
                    } catch {
                        print("getMyProfile error 1")
                    }
                }
                completionHandler(response.statusCode)
                
            case .failure(let error):
                print("getMyProfile error 3 - ", error)
                completionHandler(999)
            }
        }
    }
    
    func editMyProfile(myProfile: MyProfileModel, completionHandler: @escaping (Int) -> Void) {
        
        provider.request(.editMyProfile(model: myProfile)) { result in
            switch result {
            case .success(let response):
                print("editMyProfile API 호출 결과 - ", response.statusCode)
                completionHandler(response.statusCode)
                
            case .failure(let error):
                print("getMyProfile error - ", error)
                completionHandler(999)
            }
        }
    }
}
