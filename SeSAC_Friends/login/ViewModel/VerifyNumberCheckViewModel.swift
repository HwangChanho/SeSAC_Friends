//
//  VerifyNumberCheckViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import RxSwift
import FirebaseAuth
import RxRelay
import SwiftyJSON

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
    
    // MARK: - API Request
    func checkValidId(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.getLogin { data, code in
            switch code {
            case .success:
                UserDefaults.standard.set(data?.uid, forKey: Constants.UserInfo.userID)
                print("userID : ", data?.uid ?? "NO ID")
                completion("", code)
            case .userExist:
                completion("이미 존재하는 사용자입니다.", code)
            case .serverError:
                completion("관리자에게 문의해주세요.", code)
            default:
                completion("", code)
            }
        }
    }
    
    // MARK: - Firebase
    func checkValidate(completion: @escaping (String, VerifyNumberAuthStatus) -> Void) {
        Firebase.shared.checkValidate(verificationNumber: verificationNumber) { status in
            
            switch status {
            case .success:
                completion("", status)
            case .validityExpired, .wrongVerificationNumber:
                completion("전화번호 인증실패", status)
            case .tokenFail, .unknownError:
                completion("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", status)
            }
        }
    }
    
}
