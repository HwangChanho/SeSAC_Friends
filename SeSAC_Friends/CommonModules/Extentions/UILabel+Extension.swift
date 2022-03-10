//
//  UILabel+Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import UIKit

extension UILabel {
    func setTextColor(color: UIColor, text: String) {
        // NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr = NSMutableAttributedString(string: self.text!)

        attributedStr.addAttribute(.foregroundColor, value: color, range: (self.text! as NSString).range(of: text))

        // 설정이 적용된 text를 label의 attributedText에 저장
        self.attributedText = attributedStr
    }
}
