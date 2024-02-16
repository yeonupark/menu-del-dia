//
//  UserViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2024/02/16.
//

import Foundation
import RxCocoa
import Moya

class UserViewModel: BaseViewModel {
    
    let userPostList = BehaviorRelay(value: GetPostResponse(data: []))
    
    var userID = "" //PublishRelay<String>()
    var nickname = PublishRelay<String>()
    var profileUrl = PublishRelay<String>()
    
    let post = PublishRelay<Int>()
    let follower = PublishRelay<Int>()
    let following = PublishRelay<Int>()
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func getUserProfile(completionHandler: @escaping (Int) -> Void) {
        provider.request(.getUserProfile(id: userID)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(UserProfileResponse.self, from: response.data)
                        
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
    
    func fetchUserPost(limit: String, product_id: String) {
        provider.request(.getMyPost(parameter: GetPost(limit: limit, product_id: product_id), id: userID)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("fetch success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(GetPostResponse.self, from: response.data)
                        
                        self.userPostList.accept(result)
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
    
    func follow(_ id: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.follow(id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    
                    do {
                        let result = try JSONDecoder().decode(FollowResponse.self, from: response.data)
                        print("follow success - ", result)
                        completionHandler(result.following_status)
                    } catch {
                        print("follow decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("follow failure - ", response.statusCode, response.data)
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("follow error - ", error)
                completionHandler(false)
            }
        }
    }
    
    func unfollow(_ id: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.unfollow(id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    
                    do {
                        let result = try JSONDecoder().decode(FollowResponse.self, from: response.data)
                        print("unfollow success - ", result)
                        completionHandler(result.following_status)
                    } catch {
                        print("unfollow decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("unfollow failure - ", response.statusCode, response.data)
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("unfollow error - ", error)
                completionHandler(false)
            }
        }
    }
}
