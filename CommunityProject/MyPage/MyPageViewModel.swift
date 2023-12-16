//
//  MyPageViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/30.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class MyPageViewModel: BaseViewModel {
    
    let nickname = PublishRelay<String>()
    let profileUrl = PublishRelay<String>()
    
    let post = PublishRelay<Int>()
    let follower = PublishRelay<Int>()
    let following = PublishRelay<Int>()
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func getMyProfile(completionHandler: @escaping (Int) -> Void) {
        
        provider.request(.getMyProfile) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(MyProfileResponse.self, from: response.data)
                        
                        self.nickname.accept(result.nick)
                        if let profile = result.profile {
                            self.profileUrl.accept(profile)
                        }
                        
                        self.post.accept(result.posts.count)
                        self.follower.accept(result.followers.count)
                        self.following.accept(result.following.count)
                        
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
}

