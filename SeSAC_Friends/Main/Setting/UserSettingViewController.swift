//
//  UserSettingViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import MultiSlider

final class UserSettingViewController: UIViewController {
    // MARK: - Properties
    var didSendEventClosure: ((UserSettingViewController.Event) -> Void)?
    
    let userView = MyPageView()
    let viewModel = SettingViewModel.shared
    var disposeBag = DisposeBag()
    
    var alert = AlertView()
    
    private var keyHeight: CGFloat? // 키보드 높이 저장
    
    // MARK: - View
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = userView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindCollectionView()
        bindWithdrawlButton()
        // bindTextField()
        bindSwitch()
        
        bindNickName()
        bindGender()
        bindHobby()
        bindSlider()
        bindReview()
        bindBackGround()
        setGenderColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        print("Deinit : UserSettingViewController")
    }
    
    // MARK: - Methods
    private func showAlertController() {
        alert.activeAlert(title: "정말 탈퇴하시겠습니까?", SubTitle: "탈퇴하면 세싹 프렌즈를 이용할 수 없습니다.", button: [.cancel, .done])
        
        //메시지 창 컨트롤러를 표시
        alert.modalPresentationStyle = .overCurrentContext
        alert.handler = {
            // 회원 탈퇴
            self.viewModel.withdrawUser { message, code in
                switch code {
                case .success, .noUser:
                    self.didSendEventClosure?(.moveToOnBoarding)
                default:
                    self.showEdgeToast(message: message)
                }
            }
        }
        self.present(alert, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

// MARK: - @objc Methods

extension UserSettingViewController {
    @objc func saveUserInfo() {
        // 저장전 슬라이더는 rx연결이 불가하여 수동으로 viewmodel에 값 저장 필요.
        let ageMin = Int(userView.bottomView.slider.value[0])
        let ageMax = Int(userView.bottomView.slider.value[1])
        
        viewModel.availAge.accept([ageMin, ageMax])
        
        viewModel.postUserInfo { [self] message, code in
            switch code {
            case .success:
                showEdgeToast(message: message)
                didSendEventClosure?(.backToSetting)
            case .noUser:
                didSendEventClosure?(.moveToOnBoarding)
            default:
                showEdgeToast(message: message)
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo: NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight
        
        view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 100)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        view.transform = .identity
    }
}

// MARK: - Bind Rx
extension UserSettingViewController {
    private func bindCollectionView() {
        viewModel.title
            .bind(to: userView.topView.collectionView.rx
                    .items(cellIdentifier: TitleCell.identifier)) { index, item, cell in
                guard let dataCell: TitleCell = cell as? TitleCell else { return }
                
                dataCell.button.setTitle(item, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindWithdrawlButton() {
        userView.bottomView.withdrawlButton.rx.tap
            .bind { [self] _ in
                showAlertController()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindTextField() {
        userView.bottomView.textField.rx.text
            .orEmpty
            .bind(to: viewModel.hobby)
            .disposed(by: disposeBag)
    }
    
    private func bindSwitch() {
        userView.bottomView.availSwitch.rx
            .controlEvent(.valueChanged)
            .withLatestFrom(userView.bottomView.availSwitch.rx.value)
            .subscribe(onNext: { [self] bool in
                if bool {
                    viewModel.searchAble.accept(1)
                } else {
                    viewModel.searchAble.accept(0)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.searchAble
            .subscribe(onNext: { [self] value in
                if value == 1 {
                    userView.bottomView.availSwitch.isOn = true
                } else {
                    userView.bottomView.availSwitch.isOn = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNickName() {
        viewModel.nickName
            .asObservable()
            .map { text -> String? in
                return Optional(text)
            }
            .bind(to: self.userView.topView.name.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindReview() {
        viewModel.review
            .asObservable()
            .map { text in
                return text.joined(separator: ",")
            }
            .bind(to: self.userView.topView.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindGender() {
        viewModel.gender
            .subscribe(onNext: { [self] value in
                setGenderColor()
            })
            .disposed(by: disposeBag)
        
        userView.bottomView.maleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.gender.accept(1)
            })
            .disposed(by: disposeBag)
        
        userView.bottomView.femaleButton.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.gender.accept(0)
            })
            .disposed(by: disposeBag)
    }
    
    private func setGenderColor() {
        if viewModel.gender.value == 1 {
            userView.bottomView.buttonOn(userView.bottomView.maleButton)
            userView.bottomView.buttonOff(userView.bottomView.femaleButton)
        } else if viewModel.gender.value == 0 {
            userView.bottomView.buttonOn(userView.bottomView.femaleButton)
            userView.bottomView.buttonOff(userView.bottomView.maleButton)
        }
    }
    
    private func bindHobby() {
        viewModel.hobby
            .asObservable()
            .map { text -> String? in
                return Optional(text)
            }
            .bind(to: self.userView.bottomView.textField.rx.text)
            .disposed(by: disposeBag)
        
        userView.bottomView.textField.rx.text
            .subscribe(onNext: { [self] value in
                viewModel.hobby.accept(value!)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSlider() {
        viewModel.availAge
            .subscribe(onNext: { [self] value in
                userView.bottomView.slider.value = [CGFloat(value[0]), CGFloat(value[1])]
                userView.bottomView.sliderValueLabel.text = "\(value[0]) - \(value[1])"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBackGround() {
        viewModel.backGround
            .subscribe(onNext: { value in
                //print(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.backGroundCollections
            .subscribe(onNext: { value in
                //print(value)
            })
            .disposed(by: disposeBag)
    }
}

extension UserSettingViewController {
    enum Event {
        case moveToOnBoarding
        case backToSetting
    }
}


