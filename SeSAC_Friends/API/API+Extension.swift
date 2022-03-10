//
//  API+Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/13.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

// MARK: - API Methods (Queue)
extension APIService {
    // result type 으로 개선 필요
    func postQueue(type: Int, region: Int, long: Double, lat: Double, hf: [String], completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "type": type,
            "region": region,
            "long": long,
            "lat": lat,
            "hf": hf,
        ]
        
        RxAlamofire.requestData(.post, Endpoint.queue.url, parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postOnqueue(region: Int, lat: Double, long: Double, completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "region": region,
            "lat": lat,
            "long": long
        ]
        
        RxAlamofire.requestData(.post, Endpoint.onqueue.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteOnqueue(completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.delete, Endpoint.queue.url, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postHobbyRequestpostOnqueue(otheruid: String, completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "otheruid": otheruid
        ]
        
        RxAlamofire.requestData(.post, Endpoint.hobbyRequest.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func postHobbyAccept(otheruid: String, completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "otheruid": otheruid
        ]
        
        RxAlamofire.requestData(.post, Endpoint.hobbyAccept.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
    
    func getMyQueueState(completion: @escaping (Queue?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.get, Endpoint.myQueueState.url, headers: headers)
            .subscribe{ (header, data) in
                
                let apiState = UserEnum(rawValue: header.statusCode)!

                let decodedData = try? JSONDecoder().decode(Queue.self, from: data)
                
                completion(decodedData, apiState)
            }
            .disposed(by: disposeBag)
    }
}
