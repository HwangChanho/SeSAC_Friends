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
        
        view = nearUserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearUserView.tableView.delegate = self
        nearUserView.tableView.dataSource = self
        
        for _ in 0 ..< viewModel.data.value.fromQueueDB.count {
            buttonToggle.append(true)
            bindingFlag.append(false)
            cell.append(NearSesacCell())
        }
        
        setUI()
    }
    
    deinit {
        print("Deinit : RequestedSesacViewController")
    }
    
    // MARK: - Methods
    func setUI() {
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RequestedSesacViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.value.fromQueueDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cell[indexPath.row]
        
        cell.cardView.textField.delegate = self
        
        cell.cardView.hideView(self.buttonToggle[indexPath.row])
        
        let row = viewModel.data.value.fromQueueDB[indexPath.row]
        
        cell.buttonTapActionHandler = {
            // 요청하기
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
        self.alert.activeAlert(title: "취미 같이 하기를 요청할게요!", SubTitle: "요청이 수락되면 30분후에 리뷰를 남길 수 있어요", button: [.cancel, .done])
        self.alert.modalPresentationStyle = .overCurrentContext
        self.alert.handler = {
            self.viewModel.requestHobby(otherUid: row.uid) { [self] message, code in
                switch code {
                case .success:
                    showEdgeToast(message: message)
                    alert.dismiss(animated: true, completion: nil)
                default:
                    alert.dismiss(animated: true, completion: nil)
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
            // 180 이하일때는 더 이상 줄어들지 않게하기
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
