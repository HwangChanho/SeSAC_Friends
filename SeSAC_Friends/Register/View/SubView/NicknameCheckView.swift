//
//  NicknameCheckView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import UIKit
import SnapKit

final class NicknameCheckView: UIView, BasicViewSetup {
    // MARK: - Properties
    let textField = UnderLineTextField()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : NicknameCheckView")
    }
    
    // MARK: - Methods
    func setupView() {
        textField.setPlaceholder(placeholder: "10자 이내로 입력", color: .slpGray7)
        
        textField.textColor = .slpBlack
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .default
        textField.backgroundColor = .slpWhite
        textField.font = UIFont(name: UIFont.NSRegular, size: 14)
        textField.becomeFirstResponder()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }
    
    func setupConstraints() {
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
}

extension NicknameCheckView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .slpBlack
    }
}
