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
    
    func likeButtonClicked(_ id: String) {
        provider.request(.like) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("like success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(GetPostResponse.self, from: response.data)
                        
                    } catch {
                        print("like error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("like failure - ", response.statusCode, response.data)
                }
                
            case .failure(let error):
                print("like error - ", error)
            }
        }
    }
}
