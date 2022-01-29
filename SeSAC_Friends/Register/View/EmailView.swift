//
//  EmailVIew.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import UIKit

class EmailView: UIView, BasicViewSetup {
    // MARK: - Properties
    let label = UILabel()
    let subLabel = UILabel()
    var middleView = EmailCheckView()
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
    
    // MARK: - Methods
    func setupView() {
        middleView.backgroundColor = .slpWhite
        
        label.text = "이메일을 입력해 주세요."
        label.font = UIFont(name: UIFont.NSRegular, size: 18)
        label.numberOfLines = 0
        label.backgroundColor = .slpWhite
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        subLabel.text = "휴대폰 번호 변경 시 인증을 위해 사용돼요"
        subLabel.font = UIFont(name: UIFont.NSRegular, size: 14)
        subLabel.backgroundColor = .slpWhite
        subLabel.textColor = .slpGray7
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0
        
        button.defaultButton("다음", backGroundColor: .slpGray6, titleColor: .slpWhite)
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

