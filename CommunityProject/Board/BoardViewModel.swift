//
//  BoardViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/28.
//

import Foundation
import RxSwift
import Moya

class BoardViewModel {
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func fetchPost(limit: String, product_id: String, completionHandler: @escaping (GetPostResponse?) -> Void) {
        provider.request(.getPost(parameter: GetPost(limit: limit, product_id: product_id))) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(GetPostResponse.self, from: response.data)
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
