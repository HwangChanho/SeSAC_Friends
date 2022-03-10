//
//  HeaderView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/04.
//

import UIKit
import SnapKit

final class SettingHeaderView: UITableViewHeaderFooterView {
    
    static let headerViewID = "SettingHeaderView"
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let button = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    deinit {
        print("Deinit : SettingHeaderView")
    }
    
    private func setupHeaderView() {
        imageView.image = UIImage(named: "sesac_face0")
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.slpGray6.cgColor
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .slpWhite
        
        titleLabel.text = "Default User"
        titleLabel.font = UIFont(name: UIFont.NSRegular, size: 16)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        button.setImage(UIImage(systemName: "chevron.compact.right"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .slpGray6
    }
    
    private func configureLayout() {
        [imageView, titleLabel, button].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(13)
        }
        
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22.5)
            make.centerY.equalToSuperview()
        }
    }
}
