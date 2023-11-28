//
//  PostViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/27.
//

import Foundation
import RxSwift
import Moya

class PostViewModel {
    
    let title = PublishSubject<String>()
    let content = PublishSubject<String>()
    let hashTag = PublishSubject<String>()
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func postRequest(postModel: PostModel, completionHandler: @escaping (PostResponse?) -> Void ) {
        
        provider.request(.post(model: postModel)) { result in
            
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(PostResponse.self, from: response.data)
                        //print(result)
                        completionHandler(result)
                    } catch {
                        //print("error")
                        completionHandler(nil)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("failure - ", response.statusCode, response.data)
                    completionHandler(nil)
                }
                
            case .failure(let error):
                print("error - ", error)
                completionHandler(nil)
            }
        }
        
    }
}
