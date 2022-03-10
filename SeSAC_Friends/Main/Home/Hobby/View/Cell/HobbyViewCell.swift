//
//  HobbyViewCell.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/18.
//

import UIKit
import SnapKit

final class HobbyViewCell: UICollectionViewCell {
    static let identifier = "HobbyViewCell"
    
    var cellTapActionHandler: (() -> Void)?
    
    let shellView = UIView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        
        label.textColor = .slpBlack
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.textAlignment = .center
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .slpGreen
        button.backgroundColor = .clear
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        shellView.layer.borderWidth = 1
        shellView.layer.cornerRadius = 8
        
        addSubview(shellView)
        shellView.addSubview(stackView)
        
        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }
        
        shellView.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        label.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
    }
}

extension HobbyViewCell {
    @objc func cellTapped() {
        cellTapActionHandler?()
    }
}
