//
//  NearSesac.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol NearSesacViewControllerDelegate: AnyObject {
    func backToOnboarding()
    func backToSesacFind()
    func moveToReviewDetail(_ review: [String])
}

final class NearSesacViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: NearSesacViewControllerDelegate?
    
    private let nearUserView = NearUserView()
    private let noFriendView = NoFriendView()
    
    private let viewModel = HomeViewModel.shared
    
    var disposeBag = DisposeBag()
    
    var timer : Timer?
    var intCount = 1
    
    var buttonToggle: [Bool] = []
    var bindingFlag: [Bool] = []
    
    var reputation: [[Int]] = []
    
    var cell: [NearSesacCell] = []
    let alert = AlertView()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
        stopTimer()
    }
    
    override func loadView() {
        super.loadView()
        
        if viewModel.data.value.fromQueueDB.isEmpty {
            view = noFriendView
        } else {
            view = nearUserView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.data.value.fromQueueDB.isEmpty {
            bindButtons()
        } else {
            nearUserView.tableView.delegate = self
            nearUserView.tableView.dataSource = self
            
            for _ in 0 ..< viewModel.data.value.fromQueueDB.count {
                buttonToggle.append(true)
                bindingFlag.append(false)
                cell.append(NearSesacCell())
            }
        }
    }
    
    deinit {
        print("Deinit : NearSesacViewController")
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
                startTimer()
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        if timer != nil && timer!.isValid {
            intCount = 1
            timer!.invalidate()
            self.noFriendView.reloadButton.isEnabled = true
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NearSesacViewController: UITableViewDelegate, UITableViewDataSource {
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
extension NearSesacViewController: UITextViewDelegate {
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


// MARK: - @objc Methods
extension NearSesacViewController {
    @objc func timerCallback() {
        intCount += 1
        if intCount > 5 {
            stopTimer()
        }
    }
}
