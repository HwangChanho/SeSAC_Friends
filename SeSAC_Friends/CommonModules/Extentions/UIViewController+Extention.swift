//
//  UIViewController+Extention.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/20.
//

import UIKit
import SnapKit

extension UIViewController {
    func showEdgeToast(message : String, font: UIFont = UIFont(name: UIFont.NSRegular, size: 12)!) {
        let view = UIView()
        let toastLabel = UILabel()
        
        view.backgroundColor = .slpGreen
        view.alpha = 0.8
        
        toastLabel.font = font
        toastLabel.textColor = .slpWhite
        toastLabel.backgroundColor = .clear
        toastLabel.clipsToBounds = true
        toastLabel.text = message
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.textAlignment = .center
        
        self.view.addSubview(view)
        view.addSubview(toastLabel)
        
        view.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 22)
        }
        
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
        
        UIView.animate(withDuration: 2.0, delay: 1, options: .curveEaseOut, animations: {
            view.alpha = 0.0 }, completion: {(isCompleted) in
                view.removeFromSuperview()
            })
    }
    
    
}
