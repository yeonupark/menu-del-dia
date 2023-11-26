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
    case post(model: PostModel)
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
        case .post:
            "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join, .login, .emailValidation, .post:
            return  .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .join(let join):
            //let data = JoinModel(email: join.email, password: join.password, nick: join.nick, phoneNum: join.phoneNum, birtday: join.birtday)
            return .requestJSONEncodable(join)
        case .login(let email, let password):
            return .requestJSONEncodable(LoginModel(email: email, password: password))
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailValidation(email: email))
        case .post(let post):
            return .requestJSONEncodable(post)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .join, .login, .emailValidation :
            ["Content-Type" : "application/json",
             "SesacKey" : APIkey.sesacKey]
            
        case .post :
            ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
            "Content-Type" : "multipart/form-data",
             "SesacKey" : APIkey.sesacKey]
        }
    }
    
    
}
