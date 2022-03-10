//
//  Queue.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/13.
//

import Foundation

// MARK: - Queue
struct Queue: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

enum GenderFilter {
    case all
    case man
    case woman
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .woman
        case 1:
            self = .man
        case 2:
            self = .all
        default:
            return nil
        }
    }
}
