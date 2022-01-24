//
//  LoginMiddleView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

class LoginMiddleView: UIView, BasicViewSetup {
    // MARK: - Properties
    let label = UILabel()
    let middleView = PhoneNumberCheckView()
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
        
        label.text = "새싹 서비스 이용을 위해\n 휴대폰 번호를 입력해 주세요"
        label.font = UIFont(name: UIFont.NSRegular, size: 25)
        label.numberOfLines = 2
        label.backgroundColor = .slpWhite
        label.textAlignment = .center
        
        button.defaultButton("인증 문자 받기", backGroundColor: .slpGray6, titleColor: .slpWhite)
    }
    
    func setupConstraints() {
        addSubview(label)
        addSubview(middleView)
        addSubview(button)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 4)
            make.bottom.equalTo(middleView.snp.top)
        }
        
        middleView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 10)
            // 가로모드 생각
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(middleView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    
}
