//
//  NickNameView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import UIKit
import SnapKit

class NickNameView: UIView, BasicViewSetup {
    // MARK: - Properties
    let textField = UnderLineTextField()
    
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
        textField.setPlaceholder(placeholder: "휴대폰 번호(-없이 숫자만 입력)", color: .slpGray7)
        
        textField.textColor = .black
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.backgroundColor = .slpWhite
    }
    
    func setupConstraints() {
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    
    
    
}
