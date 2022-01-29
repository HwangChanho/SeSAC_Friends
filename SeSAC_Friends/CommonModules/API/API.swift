//
//  API.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/23.
//

import Foundation
import RxAlamofire
import Alamofire

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

enum UserEnum: Int {
    case noConnection = 0
    case success = 200
    case idTokenInvalid = 401
    case noUser = 201
    case clientError = 501
    case serverError = 500
}

