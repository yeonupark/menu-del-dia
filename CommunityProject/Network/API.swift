//
//  API.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/23.
//

import Foundation
import Moya

enum SeSacAPI {
    case join(model: JoinModel)
    case login(email: String, pw: String)
    case emailValidation(email: String)
}

extension SeSacAPI: TargetType {
    
    var baseURL: URL {
        URL(string: APIkey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .join:
            "join"
        case .login:
            "login"
        case .emailValidation:
            "validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join, .login, .emailValidation:
            return  .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .join(let join):
            let data = JoinModel(email: join.email, password: join.password, nick: join.nick)
            return .requestJSONEncodable(data)
        case .login(let email, let password):
            return .requestJSONEncodable(LoginModel(email: email, password: password))
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailValidation(email: email))
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json",
         "SesacKey" : APIkey.sesacKey]
    }
    
    
}
