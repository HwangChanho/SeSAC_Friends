//
//  NoFriendView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/25.
//

import UIKit
import SnapKit

final class NoFriendView: UIView, BasicViewSetup {
    // MARK: - Properties
    let imageView: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "empty_img")
        image.backgroundColor = .clear
        
        return image
    }()
    
    let changeHobbyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("취미 변경하기", for: .normal)
        button.backgroundColor = .slpGreen
        button.tintColor = .slpWhite
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        
        return button
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.clockwise")
        
        let newImageRect = CGRect(x: 0, y: 0, width: 22.76, height: 24)
        UIGraphicsBeginImageContext(CGSize(width: 22.76, height: 24))
        image.image?.draw(in: newImageRect)
        
        button.setImage(image.image, for: .normal)
        button.backgroundColor = .slpWhite
        button.tintColor = .slpGreen
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.slpGreen.cgColor
        
        return button
    }()
    
    let shellView = UIView()
    
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
    
    deinit {
        print("Deinit : NoFriendView")
    }
    
    // MARK: - Methods
    func setupView() {
        shellView.backgroundColor = .clear
        
        [imageView, shellView].forEach {
            addSubview($0)
        }
        
        [changeHobbyButton, reloadButton].forEach {
            shellView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(170)
        }
        
        shellView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(48)
        }
        
        changeHobbyButton.snp.makeConstraints { make in
            make.width.equalTo(287)
            make.left.equalToSuperview().offset(5)
            make.bottom.top.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.top.equalTo(changeHobbyButton.snp.top)
            make.left.equalTo(changeHobbyButton.snp.right).offset(10)
        }
    }
}
