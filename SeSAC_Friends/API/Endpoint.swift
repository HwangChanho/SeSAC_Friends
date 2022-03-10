//
//  Endpoint.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Foundation

enum Endpoint {
    case login, register
    case updateFCMToken
    case updateMyPage
    case withdraw
    case queue
    case onqueue
    case hobbyRequest
    case hobbyAccept
    case myQueueState
}

extension Endpoint {
    var url: URL {
        switch self {
        case .login, .register:
            return .makeEndpoint("/user")
        case .updateFCMToken:
            return .makeEndpoint("/user/update_fcm_token")
        case .updateMyPage:
            return .makeEndpoint("/user/update/mypage")
        case .withdraw:
            return .makeEndpoint("/user/withdraw")
        case .queue:
            return .makeEndpoint("/queue")
        case .onqueue:
            return .makeEndpoint("/queue/onqueue")
        case .hobbyRequest:
            return .makeEndpoint("/queue/hobbyrequest")
        case .hobbyAccept:
            return .makeEndpoint("/queue/hobbyaccept")
        case .myQueueState:
            return .makeEndpoint("/queue/myQueueState")
        }
    }
}

extension URL {
    static let baseURL = "http://test.monocoding.com:35484"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}


