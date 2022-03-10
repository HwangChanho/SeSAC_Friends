//
//  VerifyViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

protocol VerifyViewControllerDelegate {
    func didBackButtonTapped()
    func didNextButtonTapped()
    func moveToMain()
}

final class VerifyViewController: UIViewController {
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
    
    deinit {
        print("Deinit : VerifyViewController")
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
            .subscribe (onNext: { [self] data in
                if data {
                    verifyView.button.backgroundColor = .slpGreen
                } else {
                    verifyView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        /* Start Button */
        verifyView.button.rx.tap
            .bind(onNext: { [self] value in
                // 입력 조건에 맞고 타이머가 0이 아닐때
                if viewModel.validNum.value {
                    if verifyView.middleView.textField.time == 0 {
                        showEdgeToast(message: "입력시간이 만료 되었습니다.")
                    } else {
                        // 성공
                        checkValidateFirebaseAuthAndGetIdtoken()
                    }
                } else {
                    showEdgeToast(message: "잘못된 인증번호 입니다.")
                }
            })
            .disposed(by: disposeBag)
        
        /* Timer Button */
        verifyView.middleView.button.rx.tap
            .subscribe(onNext: { [self] data in
                verifyView.middleView.textField.setTimer(timeMin: 1, timeSec: 0, color: .slpGreen)
                verifyView.middleView.textField.timerOn()
                verifyView.middleView.button.isEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                    self.verifyView.middleView.button.isEnabled = true
                }
                
                loginViewModel.phoneNum = UserDefaults.standard.string(forKey: Constants.UserInfo.userPhoneNum) ?? ""
                loginViewModel.getVerifyNumber { state in
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

// MARK: - API Request
extension VerifyViewController {
    func checkValidId() {
        self.viewModel.checkValidId { message, code in
            switch code {
            case .success:
                // 홈화면으로 이동
                self.delegate?.moveToMain()
            case .firebaseInvalid:
                self.refreshIDToken()
            case .noUser:
                // 회원가입 화면으로 이동
                self.delegate?.didNextButtonTapped()
            default:
                self.showEdgeToast(message: message)
            }
        }
    }
    
    // id token 재발급
    func refreshIDToken() {
        Firebase.shared.getIdToken { status in
            switch status {
            case .unknownError:
                self.showEdgeToast(message: "에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                UserDefaults.standard.removeObject(forKey: Constants.UserInfo.idToken)
            case .success:
                print("success : ", status)
                // 재요청
                self.checkValidateFirebaseAuthAndGetIdtoken()
            default:
                UserDefaults.standard.removeObject(forKey: Constants.UserInfo.idToken)
                print(status)
            }
        }
    }
    
    func checkValidateFirebaseAuthAndGetIdtoken() {
        self.viewModel.checkValidate { message, status in
            switch status {
            case .success:
                // 뷰이동
                self.checkValidId()
            default:
                self.showEdgeToast(message: message)
            }
        }
    }
}
