//
//  HomeViewModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/12.
//

import Foundation
import RxSwift
import RxRelay

class HomeViewModel {
    static let shared = HomeViewModel()
    
    private init() {}
    
    let lat = BehaviorRelay<Double>(value: 37.517819364682694)
    let long = BehaviorRelay<Double>(value: 126.88647317074734)
    let region = BehaviorRelay<Int>(value: 0)
    
    let data = BehaviorRelay<Queue>(value: Queue(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    
    let title = BehaviorRelay<[String]>(value: ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간", "기타1", "기타2", "기타3"])
    
    var fromRecommend: ObservableClass<[String]> = ObservableClass([])
    
    var reputation = BehaviorRelay<[[Int]]>(value: [])
    var testReputation = BehaviorRelay<[Int]>(value: [])
    
    lazy var dfData: [String] = []
    lazy var dfUser: [String] = []
    
    // MARK: - Methods
    func caculateRegion() {
        let latTemp = String(lat.value + 90).components(separatedBy: ["."]).joined()
        let longTemp = String(long.value + 180).components(separatedBy: ["."]).joined()
        
        let latEndIdx: String.Index = latTemp.index(latTemp.startIndex, offsetBy: 4)
        let longEndIdx: String.Index = longTemp.index(longTemp.startIndex, offsetBy: 4)
        
        let latResult = String(latTemp[...latEndIdx])
        let longResult = String(longTemp[...longEndIdx])
        
        region.accept(Int([latResult, longResult].joined())!)
    }
    
    func nearFriendsData(data: [FromQueueDB]) -> [String] {
        var arr: [String] = []
        
        data.forEach {
            $0.hf.forEach {
                arr.append($0.matchString(_string: $0))
            }
        }
        
        let removedDuplicate: Set = Set(arr)
        arr = Array(removedDuplicate)
        
        return arr
    }
    
    func getHobbyData(_ data: String) -> HobbyCount {
        var arr = data.components(separatedBy: " ")
        arr = arr.filter { $0 != "" }
        
        if dfUser.count > 8 {
            return .full
        }
        
        var tempArr: [String] = []
        
        tempArr += arr
        tempArr += dfUser
        
        if tempArr.isEmpty {
            return .empty
        }
        
        let removedDuplicate: Set = Set(tempArr)
        tempArr = Array(removedDuplicate)
        
        print(tempArr)
        
        if tempArr.count > 8 {
            return .full
        }
        
        dfUser = tempArr
        
        return .success
    }
    
    // MARK: - API Methods
    func queue(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postQueue(type: 2, region: region.value, long: long.value, lat: lat.value, hf: dfUser) { data, code in
            switch code {
            case .userExist:
                completion("신고가 누적되어 이용하실 수 없습니다.", code)
            case .alreadyMatched:
                completion("약속 취소 패널티로, 1분동안 이용하실 수 없습니다", code)
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .ban2ed:
                completion("약속 취소 패널티로, 2분동안 이용하실 수 없습니다", code)
            case .ban3th:
                completion("연속으로 약속을 취소하셔서 3분동안 이용하실 수 없습니다", code)
            case .noGenderSelected:
                completion("새싹 찾기 기능을 이용하기 위해서는 성별이 필요해요!", code)
            default:
                completion("", code)
            }
        }
    }
    
    func requestHobby(otherUid: String, completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postHobbyRequestpostOnqueue(otheruid: otherUid) { [self] data, code in
            switch code {
            case .success:
                completion("취미 함께 하기 요청을 보냈습니다", code)
            case .userExist:
                //(본인)의 현재 상태를 매칭된 상태로 변경하고 팝업 화면을 dismiss합니다.
                acceptHobby(otherUid: otherUid) { message, code in
                    completion(message, code)
                }
            case .invalidNickname:
                completion("상대방이 취미 함께 하기를 그만두었습니다", code)
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
    
    func acceptHobby(otherUid: String, completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postHobbyAccept(otheruid: otherUid) { [self] data, code in
            switch code {
            case .userExist:
                completion("상대방이 이미 다른 사람과 취미를 함께하는 중입니다.", code)
            case .invalidNickname:
                completion("상대방이 취미 함께 하기를 그만두었습니다.", code)
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .alreadyMatched:
                APIService.shared.getMyQueueState { [self] data, code in
                    switch code {
                    case .success:
                        /*새싹 찾기 화면의 경우, matched가 1이라면 Toast 메시지
                         
                         5초마다 상태 확인 시: “000님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다” Toast 메시지

                         요청하기 버튼 클릭 시: “상대방도 취미 함께 하기 요청을 했습니다. 채팅방으로 이동합니다“ Toast 메시지

                         수락하기 버튼 클릭 시: “채팅방으로 이동합니다” Toast 메시지

                         채팅 화면(1_5_chatting)의 경우, dodged가 1이거나 reviewed가 1이라면 “취미 함께하기가 종료되어 채팅을 전송할 수 없습니다” Toast 메시지*/
                        print(code, "getMyQueueState")
                        completion("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", code)
                    case .userExist:
                        completion("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", code)
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
                completion("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!", code)
            default:
                completion("", code)
            }
        }
    }
    
    func deleteQueue(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.deleteOnqueue { [self] data, code in
            switch code {
            case .userExist:
                print("이미 매칭된 상태")
            case .firebaseInvalid:
                self.getFCMToken { message, statusCode in
                    switch statusCode {
                    case .success:
                        completion("", code)
                    default:
                        completion(message, code)
                    }
                }
            case .serverError:
                print("server error")
            default:
                completion("", code)
            }
        }
    }
    
    func onQueue(completion: @escaping (String, UserEnum) -> Void) {
        APIService.shared.postOnqueue(region: region.value, lat: lat.value, long: long.value) { [self] dataValue, code in
            switch code {
            case .success:
                guard let queueData = dataValue else { return }
                
                data.accept(queueData)
                
                print("data : ", data.value)
                
                var arr: [[Int]] = []
                queueData.fromQueueDB.forEach {
                    arr.append($0.reputation)
                }
                reputation.accept(arr)
                
                dfData.removeAll()
                dfData += nearFriendsData(data: queueData.fromQueueDB)
                dfData += nearFriendsData(data: queueData.fromQueueDBRequested)
                
                fromRecommend.value = queueData.fromRecommend
                
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
