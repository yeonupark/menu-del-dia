//
//  MyPageViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/30.
//

import Foundation
import RxSwift
import Moya

class MyPageViewModel: BaseViewModel {
    
    let items = Observable.just(["My Profile", "Logout", "Withdraw"])
    
    private let provider = MoyaProvider<SeSacAPI>()
    
    func callWithdrawRequest(completionHandler: @escaping (Int) -> Void) {
        provider.request(.withdraw) { result in
            switch result {
            case .success(let response):
                
                completionHandler(response.statusCode)
                
            case .failure(let error):
                print("withdraw error - ", error)
                completionHandler(999)
            }
        }
    }
}

