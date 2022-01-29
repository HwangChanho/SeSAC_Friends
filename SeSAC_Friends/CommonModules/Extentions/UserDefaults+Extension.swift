//
//  UserDefaults+Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import Foundation

extension UserDefaults {
    static var token: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserInfo.FCMtoken)!
        }
    }
    
    static var userId: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserInfo.userId)!
        }
    }
    
    static var isfirstLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isFirstLoggin)
        }
    }
    
    func saveUserDefaults(token: String, name: String, id: Int, email: String) {
        UserDefaults.standard.set(token, forKey: Constants.UserInfo.FCMtoken)
        UserDefaults.standard.set(name, forKey: Constants.UserInfo.userName)
        UserDefaults.standard.set(id, forKey: Constants.UserInfo.userId)
        UserDefaults.standard.set(email, forKey: Constants.UserInfo.userEmail)
    }
    
    func removeUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.FCMtoken)
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.userName)
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.userId)
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.userEmail)
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.password)
    }
}
