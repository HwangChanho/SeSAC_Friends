//
//  TabBarPage.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/02.
//

import UIKit

enum TabBarPage {
    case setting
    case home
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .setting
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "홈"
        case .setting:
            return "내정보"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .setting:
            return 1
        }
    }
    
    // Add tab icon value
    func pageIconImage() -> UIImage {
        switch self {
        case .home:
            return UIImage(named: "home")!
        case .setting:
            return UIImage(named: "setting")!
        }
    }
    
    // Add tab icon selected / deselected color
    func selectedIconColor() -> UIColor {
        switch self {
        case .setting, .home:
            return UIColor.slpGreen
        }
    }
    
    func unselectedIconColr() -> UIColor {
        switch self {
        case .setting, .home:
            return UIColor.slpGray6
        }
    }
    
    // etc
    func titleFont() -> UIFont {
        switch self {
        case .setting, .home:
            return UIFont(name: UIFont.NSRegular, size: 10)!
        }
    }
}
