//
//  SettingViewModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/12/13.
//

import Foundation
import RxSwift
import Moya

class SettingViewModel: BaseViewModel {
    
    let items = Observable.just(["Logout", "Withdraw"])
    
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

