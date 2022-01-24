//
//  VerifyViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

protocol VerifyViewControllerDelegate {
    func didBackButtonTapped()
}

class VerifyViewController: UIViewController {
    
    var delegate: VerifyViewControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func backButtonDidTap() {
        self.delegate?.didBackButtonTapped()
    }
    
}
