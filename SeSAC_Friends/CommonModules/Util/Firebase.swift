//
//  Firebase.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Firebase
import RxAlamofire
import Alamofire
import RxSwift

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

class Firebase: NSObject, MessagingDelegate {
    static let shared = Firebase()
    
    private let disposeBag = DisposeBag()
    
    func getFCMToken() {
        // 메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        // 현재 등록된 토큰 가져오기
        Messaging.messaging().token {token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey: Constants.UserInfo.FCMtoken)
            }
        }
    }
    
    func checkValidate(verificationNumber: String, completion: @escaping (VerifyNumberAuthStatus) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: Constants.UserInfo.firebaseAuth) ?? "", verificationCode: verificationNumber)
        
        Auth.auth().signIn(with: credential) { success, error in
            if let error = error {
                if let errorCode: AuthErrorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidVerificationCode:
                        completion(.wrongVerificationNumber)
                    default:
                        completion(.unknownError)
                    }
                }
                return
            }
            
            let currentUser = Auth.auth().currentUser
            
            currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
                if let error = error {
                    print(#function, error)
                    completion(.unknownError)
                    return;
                }
                
                UserDefaults.standard.set(idToken, forKey: Constants.UserInfo.idToken)
                
                completion(.success)
            })
        }
    }
    
    func getIdToken(completion: @escaping (VerifyNumberAuthStatus) -> Void) {
        let currentUser = Auth.auth().currentUser
        
        currentUser?.getIDTokenForcingRefresh(true, completion: { idToken, error in
            if let error = error {
                print(#function, error)
                completion(.unknownError)
                return;
            }
            
            UserDefaults.standard.set(idToken, forKey: Constants.UserInfo.idToken)
            
            completion(.success)
        })
    }
    
    func updateFCMToken(completion: @escaping (UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        let parameters: [String: Any] = [
            "FCMtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.FCMtoken)!
        ]
        
        RxAlamofire.requestData(.put, Endpoint.updateFCMToken.url, parameters: parameters, headers: headers)
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                if apiState == .firebaseInvalid {
                    self.getIdToken { code in
                        // 예외처리 필요
                        print(code)
                    }
                }
                
                completion(apiState)
            }
            .disposed(by: disposeBag)
    }
    
}
