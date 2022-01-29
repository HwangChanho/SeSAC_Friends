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
}

class GenderViewController: UIViewController {
    // MARK: - Properties
    var delegate: GenderControllerDelegate?
    
    var disposeBag = DisposeBag()
    
    let genderView = GenderView()
    let viewModel = RegisterViewModel()
    
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
    
    // MARK: - Methods
    private func bindInput() {
        genderView.middleView.maleButton.rx
            .tap
            .subscribe(onNext : {
                self.viewModel.ButtonObserver.accept(1)
                self.genderView.middleView.femaleButton.backgroundColor = .clear
            })
            .disposed(by: disposeBag)
        
        genderView.middleView.femaleButton.rx
            .tap
            .subscribe(onNext : {
                self.viewModel.ButtonObserver.accept(0)
                self.genderView.middleView.maleButton.backgroundColor = .clear
            })
            .disposed(by: disposeBag)
        
        viewModel.ButtonObserver
            .map(viewModel.checkValidButton)
            .bind(to: viewModel.valid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.valid
            .subscribe(onNext: { data in
                if data {
                    self.genderView.button.backgroundColor = .slpGreen
                } else {
                    self.genderView.button.backgroundColor = .slpGray6
                }
            })
            .disposed(by: disposeBag)
    }
    
    /* button */
    private func buttonAction() {
        genderView.button.rx.tap
            .bind {
                if self.viewModel.valid.value {
                    self.delegate?.submit()
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
