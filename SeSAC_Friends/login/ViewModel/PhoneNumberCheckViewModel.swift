//
//  PhoneNumberCheckViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import RxSwift
import FirebaseAuth
import RxRelay

enum A: Int, Error {
    case testA = 400
    case testB = 401
}

class PhoneNumberCheckViewModel {
    let phoneNumberObserver = BehaviorSubject<String>(value: "")
    var phoneNum = ""
    
    let valid = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Firebase
    
    func getVerifyNumber(completion: @escaping (PhoneNumberAuthStatus) -> Void) {
        let number = "+82 \(phoneNum)"
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
            
            if let error = error {
                let state = AuthErrorCode(rawValue: error._code)
                
                switch state {
                case .tooManyRequests:
                    completion(.tooManyRequests)
                default:
                    completion(.unknownError)
                }
                
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: Constants.UserInfo.firebaseAuth)
            completion(.success)
        }
    }
    
    // MARK: - Methods
    
    func checkValidate(text: String) -> Bool {
        let nextText = text.replacingOccurrences(of: "-", with: "")
        
        phoneNum = nextText
        
        if nextText.count >= 10 {
            let firstString = nextText[nextText.startIndex]
            let secondString = nextText[nextText.index(nextText.startIndex, offsetBy: 1)]
            
            if firstString != "0" && secondString != "1" {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func setHyphen(_ textInput: String) -> String {
        // guard var text = text else { return "" }
        var text = textInput.replacingOccurrences(of: "-", with: "")
        
        switch text.count {
        case 0 ... 3:
            text = text.replacingOccurrences(of: "-", with: "")
        case 4 ... 6: // 작대기 하나
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
        case 7 ... 10: // 작대기 두개
            let index = text.index(text.startIndex, offsetBy: 4)
            
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
            text.insert("-", at: text.index(index, offsetBy: 3))
        case 11: // 작대기 두개
            let index = text.index(text.startIndex, offsetBy: 4)
            
            text.insert("-", at: text.index(text.startIndex, offsetBy: 3))
            text.insert("-", at: text.index(index, offsetBy: 4))
        default:
            text = text.replacingOccurrences(of: "-", with: "")
            // text = text.components(separatedBy: ["-"]).joined()
        }
        
        return text
    }
}
