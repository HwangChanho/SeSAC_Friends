//
//  UnderLineTextFieldWithTimer.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/25.
//

import UIKit
import SnapKit

class UnderLineTextFieldWithTimer: UITextField {
    var mTimer: Timer?
    lazy var time: Int = 0
    
    lazy var placeholderColor: UIColor = self.tintColor
    lazy var placeholderString: String = ""
    
    private lazy var underLineView: UIView = {
        let lineView = UIView()
        
        lineView.backgroundColor = .white
        
        return lineView
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .slpBlack
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: UIFont.NSMedium, size: 15)
        label.text = "00:00"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mTimer = Timer()
        
        addSubview(underLineView)
        addSubview(timerLabel)
        
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(3)
            make.right.equalTo(self.snp.right).offset(-10)
        }
        
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit : UnderLineTextFieldWithTimer")
    }
    
    func setPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    func setPlaceholder(placeholder: String, color: UIColor) {
        placeholderString = placeholder
        placeholderColor = color
        
        setPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
    
    func setTimer(timeMin: Int?, timeSec: Int?, color: UIColor?) {
        timerLabel.textColor = color ?? UIColor.slpBlack
        
        let min = timeMin ?? 0
        let sec = timeSec ?? 0
        
        var minText = ""
        var secText = ""
        
        time = (min * 60) + (sec)
        
        if min < 10 {
            minText = "0\(min)"
        } else {
            minText = "\(min)"
        }
        
        if sec < 10 {
            secText = "0\(sec)"
        } else {
            secText = "\(sec)"
        }
        
        timerLabel.text = minText + ":" + secText
    }
}

// MARK: - Methods

extension UnderLineTextFieldWithTimer {
    @objc func editingDidBegin() {
        setPlaceholder()
        underLineView.backgroundColor = placeholderColor
    }
    
    @objc func editingDidEnd() {
        underLineView.backgroundColor = placeholderColor
    }
}

// MARK: - Timer

extension UnderLineTextFieldWithTimer {
    func timerOn() {
        print(#function)
        
        if let timer = mTimer {
            print("in")
            if !timer.isValid {
                mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        } else {
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
    
    func timerOff() {
        if let timer = mTimer {
            if(timer.isValid) {
                timer.invalidate()
            }
        }
        
        time = 0
        timerLabel.text = "00:00"
    }
    
    //타이머가 호출하는 콜백함수
    @objc private func timerCallback() {
        time -= 1
        
        if time <= 0 {
            timerOff()
        }
        
        let min = time / 60
        let sec = time % 60
        
        setTimer(timeMin: min, timeSec: sec, color: .slpGreen)
    }
}

