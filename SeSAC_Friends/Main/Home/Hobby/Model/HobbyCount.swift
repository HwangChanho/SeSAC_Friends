//
//  HobbyCount.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/25.
//

import Foundation

enum HobbyCount {
    case full
    case empty
    case success
    case invalid
    case contained
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .empty
        case 1 ... 7:
            self = .success
        case 8 ... Int.max:
            self = .full
        default:
            self = .invalid
        }
    }
}
