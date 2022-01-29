//
//  UIButton-Extension.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import UIKit

extension UIButton {
    func defaultButton(_ text: String, backGroundColor: UIColor, titleColor: UIColor) {
        self.backgroundColor = backGroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 8
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
    }
    
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        guard let imageView = self.currentImage,
              let titleLabel = self.titleLabel?.text else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        self.titleEdgeInsets = UIEdgeInsets(top: (imageView.size.height + gap) * sign, left: -imageView.size.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.size(withAttributes:[NSAttributedString.Key.font: self.titleLabel!.font!])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
}
