//
//  Timer.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/26.
//

import Foundation
import UIKit

class CustomTimer {
    var intCount = 1
    
    var maxTime: Int?
    var timer : Timer?
    
    init(maxTime: Int) {
        self.maxTime = maxTime
    }
    
    func startTimer(completion: @escaping () -> Void) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallback() {
        intCount += 1
        if intCount > maxTime ?? 0 {
            if timer != nil && timer!.isValid {
                timer!.invalidate()
            }
        }
    }
    
    func stopTimer(){
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
    }
}
