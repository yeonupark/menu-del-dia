//
//  APIModel.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/23.
//

import Foundation

struct JoinModel: Encodable {
    
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthday: String?
}

struct JoinResponse: Decodable {
    
    let _id: String
    let email: String
    let nick: String
}

struct LoginModel: Encodable {
    
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    
    let token: String
    let refreshToken: String
}

struct EmailValidation: Encodable {
    
    let email: String
}

struct EmailResponse: Decodable {
    
    let message: String
}

struct RefreshResponse: Decodable {
    
    let token: String
}

struct WithDrawResponse: Decodable {
    
    let _id: String
    let email: String
    let nick: String
}

struct PostModel: Encodable {
    
    let title: String?
    let content: String?
    let file: [Data?]?
    let product_id: String
    let content1: String?
    let content2: String?
    
}

struct PostResponse: Decodable {
    let likes, image, hashTags, comments: [String?]
    let _id, time: String
    let creator: Creator
    let title, content, product_id: String?
    
}

struct Creator: Decodable {
    let _id, nick: String
    let profile: String?

}

struct GetPost {
    let limit: String
    let product_id: String
    
    func getParameters() -> [String : String] {
        
        return ["limit" : limit, "product_id" : product_id]
    }
}

struct GetPostResponse: Decodable {
    let data: [Datum]
}

struct Datum: Decodable {
    let likes, image, hashTags: [String]
    let comments: [Comment?]
    let _id: String
    let creator: Creator
    let time: String
    let title, product_id, content, content1, content2, content3, content4, content5: String?
}

struct Comment: Decodable {
    let _id, content, time: String
    let creator: Creator
}

struct MyProfileResponse: Decodable {
    let posts: [String]
    let followers, following: [Creator]
    let _id, email, nick: String
    let phoneNum, birthDay: String?
    let profile: String?
}

struct MyProfileModel: Encodable {
    let nick, phoneNum, birthDay: String?
    let profile: Data?
}

struct LikeResponse: Decodable {
    let like_status: Bool
}

struct CommentPostData: Encodable {
    let content: String
}
