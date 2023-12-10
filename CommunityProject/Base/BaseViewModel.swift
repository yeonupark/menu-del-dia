//
//  BaseViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/30.
//

import Foundation
import Moya

class BaseViewModel {
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func callRefreshToken(completionHandler: @escaping (Bool) -> Void) {
        provider.request(.refresh) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("token refresh success - 토큰을 갱신합니다 ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(RefreshResponse.self, from: response.data)
                        UserDefaults.standard.set(result.token, forKey: "token")
                        // 토큰 갱신
                        // 다시 탈퇴 요청
                    } catch {
                        print("error")
                    }
                    
                    completionHandler(true)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("token refresh failure - 로그인 화면으로 돌아갑니다 ", response.statusCode, response.data)
                    
                    // 418 (리프레쉬토큰 만료) -> 로그인뷰컨으로 이동
                    completionHandler(false)
                }
                
            case .failure(let error):
                print("token refresh error - ", error)
            }
        
        }
    }
}
