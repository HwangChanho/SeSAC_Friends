//
//  RequestedSescViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol RequestedSesacViewControllerDelegate: AnyObject {
    func backToOnboarding()
    func backToSesacFind()
    func moveToReviewDetail(_ review: [String])
}

final class RequestedSesacViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: RequestedSesacViewControllerDelegate?
    
    private let nearUserView = NearUserView()
    private let noFriendView = NoFriendView()
    
    private let viewModel = HomeViewModel.shared
    
    var buttonToggle: [Bool] = []
    var bindingFlag: [Bool] = []
    var cell: [NearSesacCell] = []
    let alert = AlertView()
    
    var disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        
        if viewModel.data.value.fromQueueDBRequested.isEmpty {
            view = noFriendView
        } else {
            view = nearUserView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewModel.data.value.fromQueueDBRequested)
        
        if viewModel.data.value.fromQueueDBRequested.isEmpty {
            bindButtons()
        } else {
            nearUserView.tableView.delegate = self
            nearUserView.tableView.dataSource = self
            
            for _ in 0 ..< viewModel.data.value.fromQueueDBRequested.count {
                buttonToggle.append(true)
                bindingFlag.append(false)
                cell.append(NearSesacCell())
            }
        }
    }
    
    deinit {
        print("Deinit : RequestedSesacViewController")
    }
    
    // MARK: - Methods
    private func bindButtons() {
        noFriendView.changeHobbyButton.rx.tap
            .subscribe(onNext: { [self] _ in
                viewModel.deleteQueue { message, code in
                    switch code {
                    case .success:
                        delegate?.backToSesacFind()
                    case .noUser:
                        delegate?.backToOnboarding()
                    default:
                        showEdgeToast(message: message)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        noFriendView.reloadButton.rx.tap
            .subscribe(onNext: { [self] _ in
                self.noFriendView.reloadButton.isEnabled = false
                viewModel.onQueue { [self] message, code in
                    switch code {
                    case .noUser:
                        delegate?.backToOnboarding()
                    default:
                        showEdgeToast(message: message)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RequestedSesacViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.fromQueueDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cell[indexPath.row]
        
        cell.button.backgroundColor = .blue
        cell.button.setTitle("????????????", for: .normal)
        
        cell.cardView.textField.delegate = self
        
        cell.cardView.hideView(self.buttonToggle[indexPath.row])
        
        let row = viewModel.data.value.fromQueueDBRequested[indexPath.row]
        
        cell.buttonTapActionHandler = {
            // ????????????
            self.showAlert(row)
        }
        
        if !bindingFlag[indexPath.row] {
            viewModel.testReputation.accept(viewModel.reputation.value[indexPath.row])
            print(viewModel.testReputation.value)
            bindCollectionView(cell.cardView.collectionView, indexPath.row)
            bindingFlag[indexPath.row] = true
        }
        
        cell.cardView.name.text = row.nick
        cell.cardView.textField.text = row.reviews.joined(separator: ", ")
        
        if row.reviews.count > 1 {
            cell.cardView.reviewButton.isHidden = false
        }
        
        cell.cardView.buttonTapActionHandler = {
            self.buttonToggle[indexPath.row].toggle()
            self.nearUserView.tableView.reloadData()
        }
        
        cell.cardView.reviewButtonTapActionHandler = {
            self.delegate?.moveToReviewDetail(row.reviews)
        }
        
        return cell
    }
    
    private func bindCollectionView(_ collectionView: UICollectionView, _ indexPath: Int) {
        viewModel.testReputation
            .bind(to: collectionView.rx
                    .items(cellIdentifier: TitleCell.identifier)) { index, item, cell in
                if index > 5 {
                    guard let dataCell: TitleCell = cell as? TitleCell else { return }
                    
                    dataCell.isHidden = true
                    
                } else {
                    guard let dataCell: TitleCell = cell as? TitleCell else { return }
                    
                    dataCell.isHidden = false
                    
                    if item != 0 {
                        dataCell.button.backgroundColor = .slpGreen
                        dataCell.button.tintColor = .slpWhite
                    } else {
                        dataCell.button.backgroundColor = .slpWhite
                        dataCell.button.tintColor = .slpBlack
                    }
                    
                    dataCell.button.setTitle(self.viewModel.title.value[index], for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(_ row: FromQueueDB) {
        self.alert.activeAlert(title: "?????? ?????? ????????? ???????????????!", SubTitle: "????????? ???????????? 30????????? ????????? ?????? ??? ?????????", button: [.cancel, .done])
        self.alert.modalPresentationStyle = .overCurrentContext
        self.alert.handler = {
            self.viewModel.acceptHobby(otherUid: row.uid) { [self] message, code in
                switch code {
                case .success:
                    showEdgeToast(message: message)
                    // ?????????????????? ??????
                    
                default:
                    showEdgeToast(message: message)
                }
            }
        }
        self.present(self.alert, animated: false)
    }
}

// MARK: - UITextViewDelegate
extension RequestedSesacViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        print("in ", estimatedSize)
        
        textView.constraints.forEach { (constraint) in
            // 180 ??????????????? ??? ?????? ???????????? ????????????
            if estimatedSize.height <= 180 {
                
            }
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
