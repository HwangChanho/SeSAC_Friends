//
//  HobbyViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/17.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit

final class HobbyViewController: UIViewController {
    // MARK: - Properties
    var didSendEventClosure: ((HobbyViewController.Event) -> Void)?
    
    private let hobbyView = HobbyView()
    private let viewModel = HomeViewModel.shared
    
    private let searchBar = UISearchBar()
    
    var disposeBag = DisposeBag()
    let maxLength = 8
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        view = hobbyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQueueData()
        
        hobbyView.collectionView.delegate = self
        hobbyView.collectionView.dataSource = self
        
        setGesture()
        setSearchBar()
        bindRxKeyboard()
        bindSearchBar()
        bindButton()
    }
    
    deinit {
        print("Deinit : HobbyViewController")
    }
    
    // MARK: - Methods
    private func getQueueData() {
        viewModel.caculateRegion()
        viewModel.onQueue { [self] message, code in
            switch code {
            case .noUser:
                didSendEventClosure?(.moveToOnboarding)
            default:
                showEdgeToast(message: message)
            }
        }
    }
    
    private func bindButton() {
        hobbyView.button.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.queue { message, code in
                    switch code {
                    case .success:
                        didSendEventClosure?(.moveToSesacFind)
                    case .noGenderSelected:
                        showEdgeToast(message: message)
                        // 유저 세팅으로 이동
                    default:
                        showEdgeToast(message: message)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        // 텍스트 변경시
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [self] text in
                if text.count > maxLength { // 최대 8자
                    showEdgeToast(message: "취미는 8자까지 등록 가능합니다.")
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    searchBar.text = String(newString)
                }
            })
            .disposed(by: disposeBag)
        
        // search 버튼 눌렸을 경우
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [self] data in
                let hobbyCase = viewModel.getHobbyData(searchBar.text!)
                switch hobbyCase {
                case .full:
                    showEdgeToast(message: "8개까지 등록 가능합니다.")
                    return
                case .empty:
                    return
                case .success:
                    hobbyView.collectionView.reloadData()
                case .invalid:
                    showEdgeToast(message: "잘못된 값입니다.")
                    return
                case .contained:
                    showEdgeToast(message: "중복된 값입니다.")
                    return
                }
                searchBar.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    private func setGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.hobbyView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.hobbyView.addGestureRecognizer(swipeUp)
    }
    
    private func setSearchBar() {
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.titleView = searchBar
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
    }
    
    private func bindRxKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive { [self] height in
                if height == 0 {
                    hobbyView.button.layer.cornerRadius = 8
                    hobbyView.button.snp.updateConstraints { make in
                        make.left.right.equalToSuperview().inset(10)
                        make.height.equalTo(48)
                        make.bottom.equalTo(hobbyView.safeAreaLayoutGuide)
                    }
                } else {
                    hobbyView.button.layer.cornerRadius = 0
                    hobbyView.button.snp.updateConstraints {
                        $0.bottom.equalTo(hobbyView.safeAreaLayoutGuide).inset(height - hobbyView.safeAreaInsets.bottom)
                        $0.left.right.equalToSuperview()
                    }
                }
                // 애니메이션
                view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        searchBar.endEditing(true)
    }
}

// MARK: - @objc Methods
extension HobbyViewController {
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up:
                searchBar.becomeFirstResponder()
            case UISwipeGestureRecognizer.Direction.down:
                searchBar.endEditing(true)
            default:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return viewModel.fromRecommend.value.count + viewModel.dfData.count
        case 3:
            return viewModel.dfUser.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyViewCell.identifier, for: indexPath) as? HobbyViewCell else {
            return UICollectionViewCell()
        }
        
        let dfDataIndex = indexPath.row - viewModel.fromRecommend.value.count
        let recommendIndex = self.viewModel.fromRecommend.value.count
        
        switch indexPath.section {
        case 1:
            if indexPath.row >= viewModel.fromRecommend.value.count {
                cell.shellView.layer.borderColor = UIColor.slpGray5.cgColor
                cell.label.textColor = .slpBlack
                cell.label.text = viewModel.dfData[dfDataIndex]
                cell.button.isHidden = true
                cell.cellTapActionHandler = {
                    if self.viewModel.dfUser.count >= 8 {
                        self.showEdgeToast(message: "8개까지 등록 가능합니다.")
                        return
                    }
                    if !self.viewModel.dfUser.contains(self.viewModel.dfData[indexPath.row - self.viewModel.fromRecommend.value.count]) {
                        self.viewModel.dfUser.append(self.viewModel.dfData[indexPath.row - recommendIndex])
                        self.hobbyView.collectionView.reloadData()
                    }
                    
                }
            } else {
                cell.shellView.layer.borderColor = UIColor.red.cgColor
                cell.label.textColor = .red
                cell.label.text = viewModel.fromRecommend.value[indexPath.row]
                cell.button.isHidden = true
                cell.cellTapActionHandler = {
                    if self.viewModel.dfUser.count >= 8 {
                        self.showEdgeToast(message: "8개까지 등록 가능합니다.")
                        return
                    }
                    if !self.viewModel.dfUser.contains(self.viewModel.fromRecommend.value[indexPath.row]) {
                        self.viewModel.dfUser.append(self.viewModel.fromRecommend.value[indexPath.row])
                        self.hobbyView.collectionView.reloadData()
                    }
                }
            }
        case 3:
            cell.shellView.layer.borderColor = UIColor.slpGreen.cgColor
            cell.label.textColor = .slpGreen
            cell.label.text = viewModel.dfUser[indexPath.row]
            cell.button.isHidden = false
            cell.cellTapActionHandler = {
                // 셀 삭제
                self.viewModel.dfUser.remove(at: indexPath.row)
                self.hobbyView.collectionView.reloadData()
            }
        default:
            print(#function, "default")
        }
        
        return cell
    }
    
    // 섹션간 공간
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 1:
            if indexPath.row >= viewModel.fromRecommend.value.count {
                let recommendCell: UILabel = {
                    let lb = UILabel()
                    lb.font = UIFont(name: UIFont.NSRegular, size: 14)
                    lb.text = viewModel.dfData[indexPath.row - viewModel.fromRecommend.value.count]
                    lb.sizeToFit()
                    return lb
                }()
                let size = recommendCell.frame.size
                
                return CGSize(width: size.width + 10, height: size.height + 20)
            } else {
                let recommendCell: UILabel = {
                    let lb = UILabel()
                    lb.font = UIFont(name: UIFont.NSRegular, size: 14)
                    lb.text = viewModel.fromRecommend.value[indexPath.row]
                    lb.sizeToFit()
                    return lb
                }()
                let size = recommendCell.frame.size
                
                return CGSize(width: size.width + 10, height: size.height + 20)
            }
        case 3:
            let recommendCell: UILabel = {
                let lb = UILabel()
                lb.font = UIFont(name: UIFont.NSRegular, size: 14)
                lb.text = viewModel.dfUser[indexPath.row]
                lb.sizeToFit()
                return lb
            }()
            let size = recommendCell.frame.size
            
            return CGSize(width: size.width + 32, height: size.height + 20)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
        
        if indexPath.section == 0 {
            headerView.label.text = "지금 주변에는"
        } else if indexPath.section == 2 {
            headerView.label.text = "내가 하고 싶은"
        } else {
            headerView.label.text = nil
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 40)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 0)
        case 2:
            return CGSize(width: collectionView.frame.width, height: 40)
        case 3:
            return CGSize(width: collectionView.frame.width, height: 0)
        default:
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
}

// MARK: - Extension
extension HobbyViewController {
    enum Event {
        case moveToOnboarding
        case backToHome
        case moveToSesacFind
    }
}
