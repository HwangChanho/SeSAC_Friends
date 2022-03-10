//
//  LoginMiddleView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

final class VerifyMiddleView: UIView, BasicViewSetup {
    // MARK: - Properties
    let label = UILabel()
    let subLabel = UILabel()
    var middleView = PhoneNumberVerifyView()
    let button = UIButton()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .slpWhite
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : VerifyMiddleView")
    }
    
    // MARK: - Methods
    func setupView() {
        middleView.backgroundColor = .slpWhite
        
        label.text = "인증번호가 문자로 전송되었어요"
        label.font = UIFont(name: UIFont.NSRegular, size: 18)
        label.numberOfLines = 2
        label.backgroundColor = .slpWhite
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        subLabel.text = "(최대 소모 20초)"
        subLabel.font = UIFont(name: UIFont.NSRegular, size: 14)
        subLabel.backgroundColor = .slpWhite
        subLabel.textColor = .slpGray7
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0
        
        button.defaultButton("인증하고 시작하기", backGroundColor: .slpGray6, titleColor: .slpWhite)
    }
    
    func setupConstraints() {
        [label, subLabel, middleView, button].forEach {
            addSubview($0)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(UIScreen.main.bounds.height / 10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            //make.height.equalTo(UIScreen.main.bounds.height / 4)
            //make.bottom.equalTo(subLabel.snp.top)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        middleView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 10)
            // 가로모드 생각
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(middleView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    
}
