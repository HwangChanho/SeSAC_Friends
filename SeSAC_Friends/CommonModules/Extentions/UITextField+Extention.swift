//
//  UITextField+Extention.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/19.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat){
        //왼쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        //오른쪽에 여백 주기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func underLine(colors: UIColor) {
        let border = CALayer()
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.width, height: 1)
        border.borderWidth = 1
        border.backgroundColor = colors.cgColor
        
        self.layer.addSublayer(border)
    }
}
