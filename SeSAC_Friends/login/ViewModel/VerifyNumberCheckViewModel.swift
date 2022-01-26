//
//  VerifyNumberCheckViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import RxSwift
import FirebaseAuth
import RxRelay

class VerifyNumberCheckViewModel {
    let verifyNumberObserver = BehaviorSubject<String>(value: "")
    var verificationNumber = ""
    
    let validNum = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Methods
    func checkValidateNum(text: String) -> Bool {
        verificationNumber = text
        
        if text.count == 6 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Firebase
    func checkValidate(completion: @escaping (VerifyNumberAuthStatus) -> Void) {
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
            completion(.success)
        }
    }
}
