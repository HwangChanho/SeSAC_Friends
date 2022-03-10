//
//  0_1_LoginViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/20.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoginViewControllerDelegate {
    func moveToVerify()
}

final class LoginViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    var delegate: LoginViewControllerDelegate?
    
    private var disposeBag = DisposeBag()
    
    let PNCView = LoginMiddleView()
    let viewModel = PhoneNumberCheckViewModel()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = PNCView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
        buttonAction()
        
        PNCView.middleView.textField.delegate = self
    }
    
    deinit {
        print("Deinit : LoginViewController")
    }
    
    // MARK: - Methods
    private func bindInput() {
        PNCView.middleView.textField.rx.text
            .orEmpty
            .map(viewModel.setHyphen)
            .bind(to: viewModel.phoneNumberObserver)
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberObserver
            .map(viewModel.checkValidate)
            .bind(to: viewModel.valid) // 유효성 여부
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { data in
                if data {
                    self.PNCView.button.backgroundColor = .slpGreen
                } else {
                    self.PNCView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.phoneNumberObserver
            .subscribe(onNext: { value in
                self.PNCView.middleView.textField.text = value
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        PNCView.button.rx.tap
            .bind(onNext: { value in
                if self.viewModel.valid.value {
                    self.showEdgeToast(message: "전화 번호 인증 시작")
                    // firebase 통신
                    self.viewModel.getVerifyNumber { state in
                        switch state {
                        case .tooManyRequests:
                            self.showEdgeToast(message: "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.")
                        case .success:
                            self.delegate?.moveToVerify()
                        case .unknownError:
                            self.showEdgeToast(message: "에러가 발생했습니다. 다시 시도해주세요.")
                        }
                    }
                } else {
                    self.showEdgeToast(message: "잘못된 전화번호 형식입니다.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - TextFieldDelegate
extension LoginViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

// MARK: - @obj Methods

extension LoginViewController {
    @objc func certifycationButtonPressed() {
        self.delegate?.moveToVerify()
    }
}
