//
//  API.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/23.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

enum APIError: Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

enum UserEnum: Int {
    case success = 200
    case userExist = 201
    case invalidNickname = 202
    case alreadyMatched = 203
    case ban2ed = 204
    case ban3th = 205
    case noGenderSelected = 206
    case firebaseInvalid = 401
    case noUser = 406
    case serverError = 500
    case clientError = 501
}

// MARK: - API Methods (Login / MyPage)
class APIService {
    deinit {
        print("APIService Deinit")
    }
    
    static let shared = APIService()
    var disposeBag = DisposeBag()
    
    func getLogin(completion: @escaping (User?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.get, Endpoint.login.url, parameters: nil, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postRegister(phoneNum: String, FCMtoken: String, nickName: String, birth: Date, email: String, gender: Int, completion: @escaping (User?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNum,
            "FCMtoken": FCMtoken,
            "nick": nickName,
            "birth": birth,
            "email": email,
            "gender": gender
        ]
        
        print(parameters)
        
        RxAlamofire.requestData(.post, Endpoint.register.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func getUser(completion: @escaping (User?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.get, Endpoint.login.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                let decodedData = try? JSONDecoder().decode(User.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postUserInfo(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, hobby: String, completion: @escaping (User?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "searchable": searchable,
            "ageMin": ageMin,
            "ageMax": ageMax,
            "gender": gender,
            "hobby": hobby
        ]
        
        print(parameters)
        
        RxAlamofire.requestData(.post, Endpoint.updateMyPage.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(User.self, from: data)

                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postWithdraw(completion: @escaping (User?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.post, Endpoint.withdraw.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(User.self, from: data)

                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
}
