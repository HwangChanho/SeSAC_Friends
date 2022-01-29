//
//  EmailCheckView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import UIKit
import SnapKit

class EmailCheckView: UIView, BasicViewSetup {
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
        textField.setPlaceholder(placeholder: "SeSAC@gmail.com", color: .slpGray7)
        
        textField.textColor = .black
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
