//
//  GenderCheckView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import UIKit
import SnapKit

class GenderCheckView: UIView, BasicViewSetup {
    // MARK: - Properties
    let maleButton = ButtonWithHighlight()
    let femaleButton = ButtonWithHighlight()
    
    let stackView = UIStackView()
    
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
        setButtonUI(maleButton, image: "man", title: "남자")
        setButtonUI(femaleButton, image: "woman", title: "여자")
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
    }
    
    func setButtonUI(_ button: UIButton, image: String, title: String) {
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 16)
        button.setImage(UIImage(named: image), for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.slpBlack, for: .normal)
        button.contentHorizontalAlignment = .center
        button.centerImageAndButton(5, imageOnTop: true)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.slpGray3.cgColor
        button.clipsToBounds = true
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        [maleButton, femaleButton].forEach {
            stackView.addSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        maleButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(20)
            make.right.equalTo(femaleButton.snp.left).offset(-20)
            make.width.equalTo(femaleButton.snp.width)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(20)
            make.left.equalTo(maleButton.snp.right).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
        }
    }
}
