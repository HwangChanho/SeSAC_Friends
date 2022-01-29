//
//  BirthCheckView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/27.
//

import UIKit
import SnapKit

class BirthCheckView: UIView, BasicViewSetup {
    // MARK: - Properties
    let yearView = UIView()
    let monthView = UIView()
    let dayView = UIView()
    
    let stackView = UIStackView()
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    
    final let dateFormat = DateFormat(date: Date(), formatString: nil)
    
    let yearTextField = UnderLineTextField()
    let monthTextField = UnderLineTextField()
    let dayTextField = UnderLineTextField()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        
        label.text = "년"
        label.font = UIFont(name: UIFont.NSRegular, size: 15)
        label.textColor = .slpBlack
        
        return label
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        
        label.text = "월"
        label.font = UIFont(name: UIFont.NSRegular, size: 15)
        label.textColor = .slpBlack
        
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        
        label.text = "일"
        label.font = UIFont(name: UIFont.NSRegular, size: 15)
        label.textColor = .slpBlack
        
        return label
    }()
    
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
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        setTextField(yearTextField, placeholder: "1990")
        setTextField(monthTextField, placeholder: "1")
        setTextField(dayTextField, placeholder: "1")
        
        yearTextField.setDatePicker(datePicker, target: self, selector: #selector(inputDate(_:)))
        monthTextField.setDatePicker(datePicker, target: self, selector: #selector(inputDate(_:)))
        dayTextField.setDatePicker(datePicker, target: self, selector: #selector(inputDate(_:)))
        
        datePicker.addTarget(self, action: #selector(changeView(_:)), for: .valueChanged)
    }
    
    @objc private func changeView(_ sender: UIDatePicker) {
        dateFormat.date = sender.date
        
        yearTextField.text = dateFormat.yearStr
        monthTextField.text = dateFormat.monthStr
        dayTextField.text = dateFormat.dayStr
    }
    
    @objc private func inputDate(_ sender: UIDatePicker) {
        self.endEditing(true)
        
        dateFormat.date = datePicker.date
        
        yearTextField.text = dateFormat.yearStr
        monthTextField.text = dateFormat.monthStr
        dayTextField.text = dateFormat.dayStr
    }
    
    func setTextField(_ textField: UnderLineTextField, placeholder: String) {
        textField.setPlaceholder(placeholder: placeholder, color: .slpGray7)
        
        textField.textColor = .slpBlack
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .default
        textField.backgroundColor = .slpWhite
        textField.font = UIFont(name: UIFont.NSRegular, size: 14)
        textField.becomeFirstResponder()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.tintColor = .clear
    }
    
    func setupConstraints() {
        addSubview(stackView)
        
        [yearTextField, yearLabel].forEach {
            yearView.addSubview($0)
        }
        
        [monthTextField, monthLabel].forEach {
            monthView.addSubview($0)
        }
        
        [dayTextField, dayLabel].forEach {
            dayView.addSubview($0)
        }
        
        [yearView, monthView, dayView].forEach {
            stackView.addSubview($0)
        }
        
//        [yearTextField, monthTextField, dayTextField, yearLabel, monthLabel, dayLabel].forEach {
//            addSubview($0)
//        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        yearView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }

        monthView.snp.makeConstraints { make in
            make.left.equalTo(yearView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }

        dayView.snp.makeConstraints { make in
            make.left.equalTo(monthView.snp.right)
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width / 3)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(yearLabel.snp.left).offset(-10)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.left.equalTo(yearTextField.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(30)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(monthLabel.snp.left).offset(-10)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.left.equalTo(monthTextField.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(30)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(dayLabel.snp.left).offset(-10)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.left.equalTo(dayTextField.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(30)
        }
    }
}
