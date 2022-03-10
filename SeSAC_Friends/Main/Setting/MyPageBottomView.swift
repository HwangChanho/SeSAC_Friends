//
//  MyPageBottomView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/05.
//

import UIKit
import SnapKit
import MultiSlider

final class MyPageBottomView: UIView, BasicViewSetup {
    // MARK: - Properties
    let stackView = UIStackView()
    
    /* First View */
    let firstView = UIView()
    
    let genderInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "내 성별"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    let maleButton = UIButton()
    let femaleButton = UIButton()
    
    /* Second View */
    let secondView = UIView()
    
    let favouriteInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "자주 하는 취미"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    let textField: UnderLineTextField = {
        let textField = UnderLineTextField()
        
        textField.textColor = .slpBlack
        textField.font = UIFont(name: UIFont.NSRegular, size: 14)
        textField.backgroundColor = .clear
        textField.setPlaceholder(placeholder: "취미를 입력해 주세요", color: .slpGray7)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    /* Third View */
    let thirdView = UIView()
    
    let phoneNumSearchAvailInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "내 번호 검색 허용"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    let availSwitch: UISwitch = {
        let availSwitch = UISwitch()
        
        availSwitch.onTintColor = .slpGreen
        availSwitch.tintColor = .slpGray7
        
        return availSwitch
    }()
    
    /* Fourth View */
    let fourthView = UIView()
    
    let ageInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "상대방 연령대"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    let sliderValueLabel: UILabel = {
        let label = UILabel()
        
        label.text = "18 - 65"
        label.textColor = .slpGreen
        label.backgroundColor = .clear
        label.font = UIFont(name: UIFont.NSRegular, size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    let slider = MultiSlider()
    
    /* Button */
    let withdrawlButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("  회원탈퇴", for: .normal)
        button.setTitleColor(.slpBlack, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        setSlider(slider)
        
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : MyPageBottomView")
    }
    
    // MARK: - Methods
    func setSlider(_ slider: MultiSlider) {
        slider.minimumValue = 18
        slider.maximumValue = 65
        
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged) // continuous changes
        
        slider.outerTrackColor = .slpGray7
        slider.backgroundColor = .clear
        slider.tintColor = .slpGreen
        slider.orientation = .horizontal
        slider.thumbImage = UIImage(named: "round")
        slider.keepsDistanceBetweenThumbs = true
        slider.thumbCount = 2
        slider.thumbImage = UIImage(named: "round")
    }
    
    func setButton(_ button: UIButton, title: String, titleColor: UIColor, backgroundColor: UIColor, borderColor: UIColor) {
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor.cgColor
        button.layer.cornerRadius = 8
    }
    
    func buttonOn(_ button: UIButton) {
        button.backgroundColor = .slpGreen
        button.setTitleColor(.slpWhite, for: .normal)
        button.layer.borderColor = UIColor.slpGreen.cgColor
    }
    
    func buttonOff(_ button: UIButton) {
        button.backgroundColor = .slpWhite
        button.setTitleColor(.slpBlack, for: .normal)
        button.layer.borderColor = UIColor.slpGray7.cgColor
    }
    
    func setupView() {
        setButton(maleButton, title: "남자", titleColor: .slpBlack, backgroundColor: .slpWhite, borderColor: .slpGray7)
        setButton(femaleButton, title: "여자", titleColor: .slpBlack, backgroundColor: .slpWhite, borderColor: .slpGray7)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        [firstView, secondView, thirdView, fourthView, slider, withdrawlButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [genderInfoLabel, maleButton, femaleButton].forEach {
            firstView.addSubview($0)
        }
        
        [favouriteInfoLabel, textField].forEach {
            secondView.addSubview($0)
        }
        
        [phoneNumSearchAvailInfoLabel, availSwitch].forEach {
            thirdView.addSubview($0)
        }
        
        [ageInfoLabel, sliderValueLabel].forEach {
            fourthView.addSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        firstView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        secondView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom)
            make.height.equalTo(60)
        }
        
        thirdView.snp.makeConstraints { make in
            make.top.equalTo(secondView.snp.bottom)
            make.height.equalTo(60)
        }
        
        fourthView.snp.makeConstraints { make in
            make.top.equalTo(thirdView.snp.bottom)
            make.height.equalTo(60)
        }
        
        /* First View Constraints */
        
        genderInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.right.equalTo(maleButton.snp.left).offset(-10)
        }
        
        maleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.right.equalTo(femaleButton.snp.left).offset(-5)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
            make.right.equalToSuperview().offset(-5)
        }
        
        /* Second View Constraints */
        
        favouriteInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints { make in
            make.width.equalTo(164)
            make.centerY.equalToSuperview()
            make.left.equalTo(favouriteInfoLabel.snp.right)
            make.right.equalToSuperview().offset(-5)
        }
        
        /* Third View Constraints */
        
        phoneNumSearchAvailInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        availSwitch.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.centerY.equalToSuperview()
            make.left.equalTo(phoneNumSearchAvailInfoLabel.snp.right)
            make.right.equalToSuperview().offset(-5)
        }
        
        /* Fourth View Constraints */
        
        ageInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(5)
            make.right.equalTo(sliderValueLabel.snp.left).offset(-10)
        }
        
        sliderValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.lessThanOrEqualTo(44)
            make.right.equalToSuperview().offset(-5)
        }
        
        /* Slider */
        slider.snp.makeConstraints { make in
            make.top.equalTo(fourthView.snp.bottom)
        }
        
        /* Button */
        withdrawlButton.snp.makeConstraints  { make in
            
        }
    }
}

// MARK: - @objc Methods

extension MyPageBottomView {
    @objc func sliderChanged(_ sender: MultiSlider) {
        let minAge = Int(sender.value[0])
        let maxAge = Int(sender.value[1])
        
        sliderValueLabel.text = "\(minAge) - \(maxAge)"
    }
}

// MARK: - TextFieldDelegate
extension MyPageBottomView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
