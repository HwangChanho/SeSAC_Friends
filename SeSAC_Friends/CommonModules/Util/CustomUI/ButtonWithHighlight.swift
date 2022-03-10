//
//  ButtonWithHighlight.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/30.
//

import UIKit

class ButtonWithHighlight: UIButton {
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            self.backgroundColor = UIColor.slpGray3
            super.isHighlighted = newValue
        }
    }
    
}
