//
//  TitleCell.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/04.
//

import UIKit
import SnapKit

class TitleCell: UICollectionViewCell {
    static let identifier = "TitleCell"
    
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        setupView()
    }
    
    deinit {
        print("Deinit : TitleCell")
    }
    
    func setupView() {
        button.setTitle("Default", for: .normal)
        button.setTitleColor(.slpBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        button.backgroundColor = .slpWhite
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.slpGray6.cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        button.setTitleColor(.slpWhite, for: .selected)
    }
}

extension TitleCell {
    @objc func buttonAction() {
        if button.isSelected {
            button.backgroundColor = .slpGreen
        } else {
            button.backgroundColor = .slpWhite
        }
    }
}

