//
//  PhoneNumberVerifyView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import UIKit
import SnapKit

class PhoneNumberVerifyView: UIView, BasicViewSetup {
    // MARK: - Properties
    let textField = UnderLineTextFieldWithTimer()
    let button = UIButton()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    // MARK: - Methods
    func setupView() {
        textField.setPlaceholder(placeholder: "인증번호 입력", color: .slpGray7)
        textField.setTimer(timeMin: 0, timeSec: 0, color: .slpGreen)
        
        textField.textColor = .black
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.backgroundColor = .slpWhite
        textField.font = UIFont(name: UIFont.NSRegular, size: 14)
        
        button.defaultButton("재전송", backGroundColor: .slpGreen, titleColor: .slpWhite)
    }
    
    func setupConstraints() {
        [textField, button].forEach {
            addSubview($0)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalTo(button.snp.left).offset(-5)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            make.width.equalTo(72)
            make.height.equalTo(38)
        }
    }
    
    
    
    
}
