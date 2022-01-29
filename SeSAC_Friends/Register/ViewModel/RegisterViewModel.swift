//
//  NicknameViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import RxSwift
import RxRelay
import Foundation

class RegisterViewModel {
    let nickNameObserver = BehaviorRelay<String>(value: "")
    let dateObserver = BehaviorRelay<Date>(value: Date())
    let emailObserver = BehaviorRelay<String>(value: "")
    
    let ButtonObserver = BehaviorRelay<Int>(value: 0)
    
    let valid = BehaviorRelay<Bool>(value: false)
    
    var phoneNumber: Observable<String> = Observable("")
    var nickName: Observable<String> = Observable("")
    var birth: Observable<Date> = Observable(Date())
    var email: Observable<String> = Observable("")
    var gender: Observable<Int> = Observable(0)
    
    final let inputDate = DateFormat(date: Date(), formatString: nil)
    final let today = DateFormat(date: Date(), formatString: nil)
    
    // MARK: - Methods
    func checkValidButton(value: Int) -> Bool {
        
        print(value)
        
        return false
    }
    
    func checkValidEmail(text: String) -> Bool {
        email.value = text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func checkValidate(text: String) -> Bool {
        if text.count > 10 || text.count < 1 {
            return false
        } else {
            nickName.value = text
            return true
        }
    }
    
    func checkValidDate(date: Date) -> Bool {
        birth.value = date
        inputDate.date = date
        
        if (Int(today.yearStr)! - Int(inputDate.yearStr)!) > 17 {
            return true
        } else if (Int(today.yearStr)! - Int(inputDate.yearStr)!) == 17 {
            if (Int(today.monthStr)! < Int(inputDate.monthStr)!) {
                return false
            } else if (Int(today.monthStr)! == Int(inputDate.monthStr)!) {
                if (Int(today.dayStr)! < Int(inputDate.dayStr)!) {
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
//    func checkValidNickname(completion: @escaping (Data?, UserEnum) -> Void) {
//
//    }
}
