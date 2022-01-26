//
//  UIButton-Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import UIKit

extension UIButton {
    func defaultButton(_ text: String, backGroundColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = backGroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 8
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
    }
}
