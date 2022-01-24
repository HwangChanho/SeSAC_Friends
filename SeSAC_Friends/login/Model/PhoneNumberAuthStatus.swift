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
