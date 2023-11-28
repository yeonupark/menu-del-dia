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
    case getPost(parameter: GetPost)
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
        case .post, .getPost:
            "post"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join, .login, .emailValidation, .post:
            return .post
        case .getPost:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .join(let join):
            return .requestJSONEncodable(join)
        case .login(let email, let password):
            return .requestJSONEncodable(LoginModel(email: email, password: password))
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailValidation(email: email))
        case .post(let post):
            var formData: [MultipartFormData] = []
            
            if let title = post.title {
                formData.append(MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title"))
            }
            if let content = post.content {
                formData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content"))
            }
            formData.append(MultipartFormData(provider: .data(post.product_id.data(using: .utf8)!), name: "product_id"))
            
            if let file = post.file {
                formData.append(MultipartFormData(provider: .data(file), name: "file"))
            }
            if let content1 = post.content1 {
                formData.append(MultipartFormData(provider: .data(content1.data(using: .utf8)!), name: "content1"))
            }
            if let content2 = post.content2 {
                formData.append(MultipartFormData(provider: .data(content2.data(using: .utf8)!), name: "content2"))
            }
            print("데이터: ", formData)
            return .uploadMultipart(formData)
        case .getPost(let parameters):
            let parameters = parameters.getParameters()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .join, .login, .emailValidation :
            ["Content-Type" : "application/json",
             "SesacKey" : APIkey.sesacKey]
            
        case .post:
            ["Content-Type" : "multipart/form-data",
             "Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkey.sesacKey]
        
        case .getPost:
             ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkey.sesacKey]
        }
    }
    
}
