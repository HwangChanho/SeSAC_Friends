//
//  NicknameViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import UIKit
import RxSwift
import RxCocoa

protocol NicknameControllerDelegate {
    func moveToBirth()
}

final class NicknameViewController: UIViewController {
    // MARK: - Properties
    var delegate: NicknameControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let nicknameView = NicknameView()
    let viewModel = RegisterViewModel.shared
    
    var inValidID = false
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nicknameView.middleView.textField.text = viewModel.nickName.value
        
        if inValidID {
            nicknameView.middleView.textField.textColor = .red
        }
        
        bindInput()
        bindOutput()
        buttonAction()
    }
    
    deinit {
        print("Deinit : NicknameViewController")
    }
    
    // MARK: - Methods
    private func bindInput() {
        nicknameView.middleView.textField.rx.text
            .orEmpty
            .bind(to: viewModel.nickNameObserver)
            .disposed(by: disposeBag)
        
        viewModel.nickNameObserver
            .map(viewModel.checkValidate)
            .bind(to: viewModel.valid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { data in
                if data {
                    self.nicknameView.button.backgroundColor = .slpGreen
                } else {
                    self.nicknameView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        nicknameView.button.rx.tap
            .bind { value in
                if self.viewModel.valid.value {
                    self.delegate?.moveToBirth()
                } else {
                    self.showEdgeToast(message: "닉네임은 1자 이상 10자 이내만 가능합니다.")
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

