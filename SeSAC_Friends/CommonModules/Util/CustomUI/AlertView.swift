//
//  AlertView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/06.
//

import UIKit
import SnapKit

enum Button {
    case done
    case cancel
}

final class AlertView: UIViewController {
    // MARK: - Properties
    let mainView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    let buttonView = UIStackView()
    
    let doneButton = UIButton()
    let cancelButton = UIButton()
    
    var handler: (() -> Void)?
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        setUpView()
        
        view.backgroundColor = .slpBlack.withAlphaComponent(0.6)
    }
    
    deinit {
        print("Deinit : AlertView")
    }
    
    func activeAlert(title: String, SubTitle: String, button: [Button]) {
        titleLabel.text = title
        subTitleLabel.text = SubTitle
        
        for button in button {
            switch button {
            case .done:
                buttonView.addArrangedSubview(doneButton)
                doneButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            case .cancel:
                buttonView.addArrangedSubview(cancelButton)
                cancelButton.snp.makeConstraints { make in
                    make.height.equalTo(48)
                }
            }
        }
    }
    
    func setUp() {
        mainView.backgroundColor = .slpWhite
        mainView.layer.cornerRadius = 16
        
        titleLabel.textColor = .slpBlack
        titleLabel.font = UIFont(name: UIFont.NSBold, size: 16)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        
        subTitleLabel.textColor = .slpBlack
        subTitleLabel.font = UIFont(name: UIFont.NSRegular, size: 14)
        subTitleLabel.backgroundColor = .clear
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 10
        
        buttonView.backgroundColor = .clear
        
        doneButton.setTitle("확인", for: .normal)
        doneButton.setTitleColor(.slpWhite, for: .normal)
        doneButton.backgroundColor = .slpGreen
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = 8
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.slpBlack, for: .normal)
        cancelButton.backgroundColor = .slpGray2
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        buttonView.axis = .horizontal
        buttonView.distribution = .fillEqually
        buttonView.spacing = 8
    }
    
    func setUpView() {
        view.addSubview(mainView)
        
        [titleLabel, subTitleLabel, buttonView].forEach {
            mainView.addSubview($0)
        }
        
        mainView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.greaterThanOrEqualTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - @objc Methods
extension AlertView {
    @objc func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func doneButtonPressed(_ sender: UIButton) {
        handler?()
    }
}
