//
//  User.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/27.
//

import Foundation

class User {
    static let shared = User()
    
    var phoneNumber: String?
    var FCMToken: String?
    var nickName: String?
    var birth: String?
    var email: String?
    var gender: Int?
    
    private init() {}
}
