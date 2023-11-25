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
