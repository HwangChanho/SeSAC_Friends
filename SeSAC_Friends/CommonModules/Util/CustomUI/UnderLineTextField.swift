//
//  UnderLinewTextField.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/23.
//

import UIKit
import SnapKit

class UnderLineTextField: UITextField {
    lazy var placeholderColor: UIColor = self.tintColor
    lazy var placeholderString: String = ""
    
    private lazy var underLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(underLineView)
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    func setPlaceholder(placeholder: String, color: UIColor) {
        placeholderString = placeholder
        placeholderColor = color
        
        setPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
}

// MARK: - Methods

extension UnderLineTextField {
    @objc func editingDidBegin() {
        setPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
    
    @objc func editingDidEnd() {
        underLineView.backgroundColor = placeholderColor
    }
}
