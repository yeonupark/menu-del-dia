//
//  MyPageViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/30.
//

import Foundation
import Moya

class MyPageViewModel: BaseViewModel {
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func callWithdrawRequest(completionHandler: @escaping (Int) -> Void) {
        provider.request(.withdraw) { result in
            switch result {
            case .success(let response):
//                if (200..<300).contains(response.statusCode) {
//                    print("success - ", response.statusCode, response.data)
//                    
//                    do {
//                        let result = try JSONDecoder().decode(WithDrawResponse.self, from: response.data)
//                        print(result)
//                        // 성공 -> 로그인뷰컨으로 이동
//                        return 200
//                    } catch {
//                        print("error")
//                    }
//                    
//                } else if (400..<501).contains(response.statusCode) {
//                    print("failure - ", response.statusCode, response.data)
//                    // 419 (토큰 만료) -> 토큰 리프레쉬 요청
//                    self.callRefreshToken()
//                    print(response.description)
//                }
                completionHandler(response.statusCode)
                
            case .failure(let error):
                print("error - ", error)
                completionHandler(999)
            }
        }
    }
}

