//
//  Endpoint.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Foundation

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint {
    case signup
}

extension Endpoint {
    var url: URL {
        switch self {
        case .signup:
            return .makeEndpoint("/auth/local/register")
        }
    }
}

extension URL {
    static let baseURL = "http://test.monocoding.com:35484"
    
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}
