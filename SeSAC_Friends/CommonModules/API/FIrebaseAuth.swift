//
//  FIrebaseAuth.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import Foundation
import FirebaseAuth

// MARK: - ErrorAPIReturns
struct AuthErrorAPIReturns: Codable {
    let varification: String
    let error: String
    // let message: [Datum]
}

class AuthClass {
    
    func sendAuth(_ text: String, completion: @escaping (AuthErrorAPIReturns?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(text, uiDelegate: nil) { varification, error in
            if error == nil {
                print("error")
            } else {
                print("Phone Varification Error: \(error.debugDescription)")
            }
            
            // completion(varification, error)
        }
    }
}
