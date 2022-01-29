//
//  Firebase.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Firebase

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
    
}
