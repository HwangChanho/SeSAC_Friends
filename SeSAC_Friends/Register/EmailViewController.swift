//
//  EmailViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

protocol EmailControllerDelegate {
    func moveToGender()
}

final class EmailViewController: UIViewController {
    // MARK: - Properties
    var delegate: EmailControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let emailView = EmailView()
    let viewModel = RegisterViewModel.shared
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = emailView
        
        emailView.middleView.textField.text = viewModel.email.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
        buttonAction()
    }
    
    deinit {
        print("Deinit : EmailViewController")
    }
    
    // MARK: - Methods
    private func bindInput() {
        emailView.middleView.textField.rx.text
            .orEmpty
            .bind(to: viewModel.nickNameObserver)
            .disposed(by: disposeBag)
        
        viewModel.nickNameObserver
            .map(viewModel.checkValidEmail)
            .bind(to: viewModel.valid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { data in
                if data {
                    self.emailView.button.backgroundColor = .slpGreen
                } else {
                    self.emailView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        emailView.button.rx.tap
            .bind { value in
                if self.viewModel.valid.value {
                    self.delegate?.moveToGender()
                } else {
                    self.showEdgeToast(message: "이메일 형식이 올바르지 않습니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

