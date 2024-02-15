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
    case refresh
    case withdraw
    case post(model: PostModel)
    case getPost(parameter: GetPost)
    case getMyProfile
    case editMyProfile(model: MyProfileModel)
    case like(id: String)
    case comment(id: String, content: String)
    case follow(id: String)
    case unfollow(id: String)
}

extension SeSacAPI: TargetType {
    
    var baseURL: URL {
        
        switch self {
        case .join, .login, .emailValidation, .refresh, .withdraw:
            URL(string: APIkey.testURL)!
        case .post, .getPost, .getMyProfile, .editMyProfile, .like, .comment, .follow, .unfollow:
            URL(string: APIkey.baseURL)!
        }
    
    }
    
    var path: String {
        switch self {
        case .join:
            "join"
        case .login:
            "login"
        case .emailValidation:
            "validation/email"
        case .refresh:
            "refresh"
        case .withdraw:
            "withdraw"
        case .post, .getPost:
            "post"
        case .getMyProfile, .editMyProfile:
            "profile/me"
        case .like(let id):
            "post/like/\(id)"
        case .comment(let id, _):
            "post/\(id)/comment"
        case .follow(let id), .unfollow(let id):
            "follow/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join, .login, .emailValidation, .post, .like, .comment, .follow:
            return .post
        case .getPost, .refresh, .withdraw, .getMyProfile:
            return .get
        case .editMyProfile:
            return .put
        case .unfollow:
            return .delete
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
        case .refresh:
            return .requestPlain
        case .withdraw:
            return .requestPlain
        case .post(let post):
            var formData: [MultipartFormData] = []
            
            if let title = post.title {
                formData.append(MultipartFormData(provider: .data(title.data(using: .utf8)!), name: "title"))
            }
            if let content = post.content {
                formData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content"))
            }
            formData.append(MultipartFormData(provider: .data(post.product_id.data(using: .utf8)!), name: "product_id"))
            
            if let files = post.file {
                for file in files {
                    if let file = file {
                        formData.append(MultipartFormData(provider: .data(file), name: "file", fileName: "file.jpeg", mimeType: "image/jpeg"))
                    }
                }
            }
            
            if let content1 = post.content1 {
                formData.append(MultipartFormData(provider: .data(content1.data(using: .utf8)!), name: "content1"))
            }
            if let content2 = post.content2 {
                formData.append(MultipartFormData(provider: .data(content2.data(using: .utf8)!), name: "content2"))
            }
            return .uploadMultipart(formData)
        case .getPost(let parameters):
            let parameters = parameters.getParameters()
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getMyProfile:
            return .requestPlain
        case .editMyProfile(let model):
            var formData: [MultipartFormData] = []
            
            if let nick = model.nick {
                formData.append(MultipartFormData(provider: .data(nick.data(using: .utf8)!), name: "nick"))
            }
            if let birthDay = model.birthDay {
                formData.append(MultipartFormData(provider: .data(birthDay.data(using: .utf8)!), name: "birthDay"))
            }
            if let phoneNum = model.phoneNum {
                formData.append(MultipartFormData(provider: .data(phoneNum.data(using: .utf8)!), name: "phoneNum"))
            }
            if let profile = model.profile {
                formData.append(MultipartFormData(provider: .data(profile), name: "profile", fileName: "profile.jpeg", mimeType: "image/jpeg"))
            }
            return .uploadMultipart(formData)
        case .like:
            return .requestPlain
        case .comment(_, let comment):
            return .requestJSONEncodable(CommentPostData(content: comment))
        case .follow:
            return .requestPlain
        case .unfollow:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .join, .login, .emailValidation :
            ["Content-Type" : "application/json",
             "SesacKey" : APIkey.sesacKey]
            
        case .post, .editMyProfile:
            ["Content-Type" : "multipart/form-data",
             "Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkey.sesacKey]
            
        case .refresh:
            ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkey.sesacKey,
             "Refresh" : UserDefaults.standard.string(forKey: "refreshToken") ?? ""]
        
        case .withdraw, .getPost, .getMyProfile, .like, .follow, .unfollow:
             ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkey.sesacKey]
        case .comment:
            ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "Content-Type" : "application/json",
             "SesacKey" : APIkey.sesacKey]
        }
        
    }
    
}
