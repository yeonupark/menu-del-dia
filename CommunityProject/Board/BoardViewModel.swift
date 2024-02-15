//
//  BoardViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class BoardViewModel {
    
    let board = BehaviorRelay(value: GetPostResponse(data: []))
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func fetchPost(limit: String, product_id: String) {
        provider.request(.getPost(parameter: GetPost(limit: limit, product_id: product_id))) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("fetch success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(GetPostResponse.self, from: response.data)
                        
                        self.board.accept(result)
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
    
    func likeButtonClicked(_ id: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.like(id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    
                    do {
                        let result = try JSONDecoder().decode(LikeResponse.self, from: response.data)
                        print("like success - ", result)
                        completionHandler(result.like_status)
                    } catch {
                        print("like decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("like failure - ", response.statusCode, response.data)
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("like error - ", error)
                completionHandler(false)
            }
        }
    }
    
    func postComment(id: String, content: String) {
        provider.request(.comment(id: id, content: content)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    
                    do {
                        let result = try JSONDecoder().decode(Comment.self, from: response.data)
                        print("comment send success - ", result)
                    } catch {
                        print("comment send decoding error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("comment send failure - ", response.statusCode, response.data)
                }
                
            case .failure(let error):
                print("comment send error - ", error)
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
