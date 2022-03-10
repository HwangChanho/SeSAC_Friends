//
//  SettingViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/03.
//

import RxSwift
import RxRelay
import Foundation

class SettingViewModel {
    static let shared = SettingViewModel()
    
    private init() {}
    
    let data = BehaviorRelay<[String]>(value: ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "이용 약관"])
    
    let title = BehaviorRelay<[String]>(value: ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"])
    
    let nickName = BehaviorRelay<String>(value: "Default User")
    let gender = BehaviorRelay<Int>(value: 0)
    let hobby = BehaviorRelay<String>(value: "")
    let searchAble = BehaviorRelay<Int>(value: 0)
    let availAge = BehaviorRelay<[Int]>(value: [])
    let review = PublishRelay<[String]>()
    let reputation = BehaviorRelay<[Int]>(value: [])
    
    let backGround = BehaviorRelay<Int>(value: 0)
    let backGroundCollections = BehaviorRelay<[Int]>(value: [])
}

// MARK: - UserSetting
extension SettingViewModel {
    func withdrawUser(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postWithdraw { data, code in
            switch code {
            case .success:
                completion("", code)
                UserDefaults.standard.removeObject(forKey: Constants.UserInfo.idToken)
                UserDefaults.standard.removeObject(forKey: Constants.isFirstLoggin)
                UserDefaults.standard.removeObject(forKey: Constants.UserInfo.FCMtoken)
                //#Test Server : Back-end에서 firebase auth 즉시삭제 및 DB 즉시삭제 진행
                //#Real Server : Back-end에서 회원 삭제 대기열 운영 + 요청 14일 후 삭제진행
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            default:
                completion("", code)
            }
        }
    }
    
    func postUserInfo(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postUserInfo(searchable: searchAble.value, ageMin: availAge.value[0], ageMax: availAge.value[1], gender: gender.value, hobby: hobby.value) { data, code in
            switch code {
            case .success:
                completion("저장 성공", code)
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            default:
                completion("", code)
            }
        }
    }
    
    func bindAPIData(data: User?) {
        guard let data = data else { return }
        
        print(data)
        
        backGround.accept(data.background)
        backGroundCollections.accept(data.backgroundCollection)
        
        nickName.accept(data.nick)
        gender.accept(data.gender)
        hobby.accept(data.hobby)
        searchAble.accept(data.searchable)
        availAge.accept([data.ageMin, data.ageMax])
        review.accept(data.reviewedBefore)
        reputation.accept(data.reputation)
    }
    
    func getUserInfo(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.getUser { [self] data, code in
            switch code {
            case .success:
                // data 표시
                bindAPIData(data: data)
                completion("", code)
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
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
