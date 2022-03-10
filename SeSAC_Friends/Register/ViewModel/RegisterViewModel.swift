//
//  NicknameViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import Foundation

import Alamofire
import RxSwift
import RxRelay
import RxAlamofire

class RegisterViewModel {
    static let shared = RegisterViewModel()
    
    private init() {}
    
    let nickNameObserver = BehaviorRelay<String>(value: "")
    let dateObserver = BehaviorRelay<Date>(value: Date())
    let emailObserver = BehaviorRelay<String>(value: "")
    
    let ButtonObserver = BehaviorRelay<Int>(value: -1)
    
    let valid = BehaviorRelay<Bool>(value: false)
    
    var nickName: ObservableClass<String> = ObservableClass("")
    var birth: ObservableClass<Date> = ObservableClass(Date())
    var email: ObservableClass<String> = ObservableClass("")
    var gender: ObservableClass<Int> = ObservableClass(0)
    
    private let disposeBag = DisposeBag()
    
    final let inputDate = DateFormat(date: Date(), formatString: nil)
    final let today = DateFormat(date: Date(), formatString: nil)
    
    // MARK: - Methods
    func checkValidButton(genderValue: Int) -> Bool {
        gender.value = ButtonObserver.value
        
        if genderValue == 1 || genderValue == 0 {
            return true
        }
        
        return false
    }
    
    func checkValidEmail(text: String) -> Bool {
        email.value = text
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    func checkValidate(text: String) -> Bool {
        nickName.value = text
        
        if text.count > 10 || text.count < 1 {
            return false
        } else {
            return true
        }
    }
    
    func checkValidDate(date: Date) -> Bool {
        inputDate.date = date
        birth.value = date
        
        let yearCheck = Calendar.current.dateComponents([.year], from: inputDate.date!, to: today.date!).year ?? 0
        
        if yearCheck >= 17 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - API Request
    func postRegister(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postRegister(phoneNum: UserDefaults.standard.string(forKey: Constants.UserInfo.userPhoneNum)!,
                                       FCMtoken: UserDefaults.standard.string(forKey: Constants.UserInfo.FCMtoken)!,
                                       nickName: nickName.value,
                                       birth: birth.value,
                                       email: email.value,
                                       gender: gender.value) { data, code in
            
            switch code {
            case .success:
                UserDefaults.standard.set(data?.uid, forKey: Constants.UserInfo.userID)
                completion("", code)
            case .userExist:
                completion("이미 가입된 유저입니다.", code)
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("OK", code)
                    default:
                        completion(message, code)
                    }
                }
            default:
                completion("", code)
            }
        }
    }
    
    func getFCMToken(completion: @escaping (String, UserEnum) -> Void) {
        Firebase.shared.updateFCMToken { status in
            switch status {
            case .serverError:
                completion("에러가 발생했습니다. 잠시 후 다시 시도해주세요.", status)
            default:
                completion("", status)
            }
        }
    }
}
