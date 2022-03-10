//
//  NearSesacCell.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/26.
//

import UIKit
import SnapKit

final class NearSesacCell: UITableViewCell {
    static let identifier = "NearSesacCell"
    
    var buttonTapActionHandler: (() -> Void)?
    
    let cardView = CardView()
    
    let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("요청하기", for: .normal)
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        button.backgroundColor = .red
        button.tintColor = .slpWhite
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [cardView, button].forEach {
            contentView.addSubview($0)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.bottom.right.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
    }
}

extension NearSesacCell {
    @objc func buttonTapped(_ sender: UIButton) {
        buttonTapActionHandler?()
    }
}
