//
//  SettingModel.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/03.
//

import UIKit

enum SettingModel {
    case notice
    case questions
    case request
    case setAlarm
    case agreement
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .notice
        case 1:
            self = .questions
        case 2:
            self = .request
        case 3:
            self = .setAlarm
        case 4:
            self = .agreement
        default:
            return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .notice:
            return 0
        case .questions:
            return 1
        case .request:
            return 2
        case .setAlarm:
            return 3
        case .agreement:
            return 4
        }
    }
    
    func cellTitleValue() -> String {
        switch self {
        case .notice:
            return "공지사항"
        case .questions:
            return "자주 묻는 질문"
        case .request:
            return "1:1 문의"
        case .setAlarm:
            return "알림 설정"
        case .agreement:
            return "이용 약관"
        }
    }
    
    func cellIconImage() -> UIImage {
        switch self {
        case .notice:
            return UIImage(named: "notice")!
        case .questions:
            return UIImage(named: "faq")!
        case .request:
            return UIImage(named: "qna")!
        case .setAlarm:
            return UIImage(named: "setting_alarm")!
        case .agreement:
            return UIImage(named: "permit")!
        }
    }
}
