//
//  VerifyNumberCheckViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import RxSwift
import FirebaseAuth
import RxRelay
import RxAlamofire
import Alamofire

class VerifyNumberCheckViewModel {
    let verifyNumberObserver = BehaviorSubject<String>(value: "")
    var verificationNumber = ""
    
    let validNum = BehaviorRelay<Bool>(value: false)
    let loginList = PublishSubject<Login>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    func checkValidateNum(text: String) -> Bool {
        verificationNumber = text
        
        if text.count == 6 {
            return true
        } else {
            return false
        }
    }
    
    func checkValidId(completion: @escaping (Data?, UserEnum) -> Void) {
        let headers: HTTPHeaders = [
            "accept": "application/json",
            "idtoken": UserDefaults.standard.string(forKey: Constants.UserInfo.idToken)!
        ]
        
        RxAlamofire.requestData(.get, Endpoint.login.url, parameters: nil, headers: headers)
            .debug()
            .subscribe{ (header, data) in
                let apiState = UserEnum(rawValue: header.statusCode)!
                
                completion(data, apiState)
            }
            .disposed(by: disposeBag)
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
}
