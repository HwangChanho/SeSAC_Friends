//
//  GenderViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import UIKit
import RxSwift
import RxCocoa

protocol GenderControllerDelegate {
    func submit()
    func backToNickname()
}

final class GenderViewController: UIViewController {
    // MARK: - Properties
    var delegate: GenderControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let genderView = GenderView()
    let viewModel = RegisterViewModel.shared
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
        buttonAction()
    }
    
    deinit {
        print("Deinit : GenderViewController")
    }
    
    // MARK: - Methods
    private func bindInput() {
        genderView.middleView.maleButton.rx
            .tap
            .subscribe(onNext : { [self] in
                viewModel.ButtonObserver.accept(1)
                genderView.middleView.femaleButton.backgroundColor = .clear
            })
            .disposed(by: disposeBag)
        
        genderView.middleView.femaleButton.rx
            .tap
            .subscribe(onNext : { [self] in
                viewModel.ButtonObserver.accept(0)
                genderView.middleView.maleButton.backgroundColor = .clear
            })
            .disposed(by: disposeBag)
        
        viewModel.ButtonObserver
            .map(viewModel.checkValidButton)
            .bind(to: viewModel.valid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { [self] data in
                if data {
                    genderView.button.backgroundColor = .slpGreen
                } else {
                    genderView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        genderView.button.rx.tap
            .bind {
                if self.viewModel.valid.value {
                    self.register()
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - API Methods
extension GenderViewController {
    func register() {
        self.viewModel.postRegister { message, code in
            switch code {
            case .success:
                self.delegate?.submit()
            case .invalidNickname:
                self.delegate?.backToNickname()
            case .firebaseInvalid:
                // ID Token 갱신
                if message == "OK" {
                    self.register()
                } else {
                    self.showEdgeToast(message: message)
                }
            default:
                self.showEdgeToast(message: message)
            }
        }
    }
}
