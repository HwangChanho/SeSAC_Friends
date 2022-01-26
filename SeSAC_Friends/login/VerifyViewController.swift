//
//  VerifyViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol VerifyViewControllerDelegate {
    func didBackButtonTapped()
    func didNextButtonTapped()
}

class VerifyViewController: UIViewController {
    // MARK: - Properties
    var delegate: VerifyViewControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let verifyView = VerifyMiddleView()
    let viewModel = VerifyNumberCheckViewModel()
    let loginViewModel = PhoneNumberCheckViewModel()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showEdgeToast(message: "인증번호를 보냈습니다.")
    }
    
    override func loadView() {
        super.loadView()
        
        view = verifyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
        buttonAction()
    }
    
    // MARK: - Methods
    private func bindInput() {
        verifyView.middleView.textField.rx.text
            .orEmpty
            .bind(to: viewModel.verifyNumberObserver)
            .disposed(by: disposeBag)
        
        viewModel.verifyNumberObserver
            .map(viewModel.checkValidateNum)
            .bind(to: viewModel.validNum)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.validNum
            .subscribe (onNext: { data in
                if data {
                    self.verifyView.button.backgroundColor = .slpGreen
                } else {
                    self.verifyView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        /* Start Button */
        verifyView.button.rx.tap
            .bind(onNext: { value in
                // 입력 조건에 맞고 타이머가 0이 아닐때
                if self.viewModel.validNum.value {
                    if self.verifyView.middleView.textField.time == 0 {
                        self.showEdgeToast(message: "입력시간이 만료 되었습니다.")
                    } else {
                        // 성공
                        self.viewModel.checkValidate { status in
                            switch status {
                            case .validityExpired:
                                self.showEdgeToast(message: "전화번호 인증실패")
                            case .wrongVerificationNumber:
                                self.showEdgeToast(message: "전화번호 인증실패")
                            case .tokenFail:
                                self.showEdgeToast(message: "에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                            case .unknownError:
                                self.showEdgeToast(message: "에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                            case .success:
                                // 뷰이동
                                print("sucess")
                                self.delegate?.didNextButtonTapped()
                            }
                        }
                    }
                } else {
                    self.showEdgeToast(message: "잘못된 인증번호 입니다.")
                }
            })
            .disposed(by: disposeBag)
        
        /* Timer Button */
        verifyView.middleView.button.rx.tap
            .subscribe(onNext: { data in
                self.verifyView.middleView.textField.setTimer(timeMin: 1, timeSec: 0, color: .slpGreen)
                self.verifyView.middleView.textField.timerOn()
                self.verifyView.middleView.button.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.verifyView.middleView.button.isEnabled = true
                }
                
                self.loginViewModel.phoneNum = UserDefaults.standard.string(forKey: Constants.UserInfo.userPhoneNum) ?? ""
                self.loginViewModel.getVerifyNumber { state in
                    switch state {
                    case .tooManyRequests:
                        self.showEdgeToast(message: "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요.")
                    case .success:
                        self.showEdgeToast(message: "인증번호를 보냈습니다.")
                    case .unknownError:
                        self.showEdgeToast(message: "에러가 발생했습니다. 다시 시도해주세요.")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - @objc Methods
extension VerifyViewController {
    
}
