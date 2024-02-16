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
    
    let myPostList = BehaviorRelay(value: GetPostResponse(data: []))
    
    var userID = ""
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
                        
                        self.userID = result._id
                        
                        self.nickname.accept(result.nick)
                        if let profile = result.profile {
                            self.profileUrl.accept(profile)
                        }
                        self.post.accept(result.posts.count)
                        self.follower.accept(result.followers.count)
                        self.following.accept(result.following.count)
                        print(result)
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
    
    func fetchMyPost(limit: String, product_id: String) {
        provider.request(.getMyPost(parameter: GetPost(limit: limit, product_id: product_id), id: userID)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("fetch success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(GetPostResponse.self, from: response.data)
                        
                        self.myPostList.accept(result)
                    } catch {
                        print("fetch error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("fetch failure - ", response.statusCode, response.data)
                }
                
            case .failure(let error):
                print("fetch error - ", error)
            }
        }
    }
}

