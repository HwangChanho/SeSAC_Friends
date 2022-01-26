//
//  PhoneNumberAuthStatus.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import Foundation

enum PhoneNumberAuthStatus: Error {
    case tooManyRequests
    case success
    case unknownError
}

enum VerifyNumberAuthStatus: Int, Error {
    case validityExpired
    case wrongVerificationNumber = 17044
    case tokenFail
    case unknownError
    case success
}
