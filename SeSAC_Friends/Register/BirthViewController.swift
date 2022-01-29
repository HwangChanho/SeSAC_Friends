//
//  BirthViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/27.
//

import UIKit
import RxSwift
import RxCocoa

protocol BirthControllerDelegate {
    func moveToEmail()
}

class BirthViewController: UIViewController {
    // MARK: - Properties
    var delegate: BirthControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let birthView = BirthView()
    let viewModel = RegisterViewModel()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        
        view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInput()
        bindOutput()
        buttonAction()
    }
    
    // MARK: - Methods
    private func bindInput() {
        birthView.middleView.datePicker.rx.date
            .bind(to: viewModel.dateObserver)
            .disposed(by: disposeBag)
        
        viewModel.dateObserver
            .map(viewModel.checkValidDate)
            .bind(to: viewModel.valid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { data in
                if data {
                    self.birthView.button.backgroundColor = .slpGreen
                } else {
                    self.birthView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        birthView.button.rx.tap
            .bind { value in
                if self.birthView.middleView.yearTextField.text!.isEmpty || self.birthView.middleView.monthTextField.text!.isEmpty || self.birthView.middleView.dayTextField.text!.isEmpty{
                    self.showEdgeToast(message: "생년월일을 선택해주세요.")
                } else {
                    if self.viewModel.valid.value {
                        self.delegate?.moveToEmail()
                    } else {
                        self.showEdgeToast(message: "새싹친구는 만 17세 이상만 사용할 수 있습니다.")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
