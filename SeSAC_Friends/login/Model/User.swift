//
//  Login.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Foundation

// MARK: - Login
struct User: Codable {
    let id: String
    let v: Int
    let uid, phoneNumber, email, fcMtoken: String
    let nick, birth: String
    let gender: Int
    let hobby: String
    let comment: [String]
    let reputation: [Int]
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionID, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case uid, phoneNumber, email
        case fcMtoken = "FCMtoken"
        case nick, birth, gender, hobby, comment, reputation, sesac, sesacCollection, background, backgroundCollection, purchaseToken
        case transactionID = "transactionId"
        case reviewedBefore, reportedNum, reportedUser, dodgeNum, ageMin, ageMax, searchable, createdAt
    }
}
