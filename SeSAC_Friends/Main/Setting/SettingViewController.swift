//
//  SettingViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/01.
//

// rxalamo 디버그 제거, unretaindself

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SettingViewController: UIViewController {
    // MARK: - Properties
    var didSendEventClosure: ((SettingViewController.Event) -> Void)?
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let viewModel = SettingViewModel.shared
    
    var disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .slpWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        tableView.delegate = self
    }
    
    deinit {
        print("Deinit : SettingViewController")
    }
    
    // MARK: - Methods
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = .slpWhite
        tableView.rowHeight = 74
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(SettingHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingHeaderView.headerViewID)
        
        viewModel.data
            .observe(on: MainScheduler.instance)
            .filter { !$0.isEmpty }
            .bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: String) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                let model = SettingModel(index: index)
                
                var content = cell.defaultContentConfiguration()
                content.image = model?.cellIconImage()
                content.imageProperties.tintColor = .black
                content.imageToTextPadding = 14
                
                content.attributedText = NSAttributedString(string: element, attributes: [
                    .font: UIFont(name: UIFont.NSRegular, size: 16)!,
                    .foregroundColor: UIColor.slpBlack
                ])
                
                cell.contentConfiguration = content
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UITableViewDelegate
// 헤더뷰 정의
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingHeaderView.headerViewID) as? SettingHeaderView else { return UIView() }
        
        viewModel.nickName
            .asObservable()
            .map { text -> String? in
                return Optional(text)
            }
            .bind(to: headerView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        headerView.addGestureRecognizer(tapRecognizer)
        
        tapRecognizer.rx.event
            .asDriver()
            .drive { [self] _ in
                didSendEventClosure?(.moveToUserSetting)
            }
            .disposed(by: disposeBag)

        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func getUserInfo() {
        self.viewModel.getUserInfo { [self] message, code in
            switch code {
            case .noUser:
                // 온보딩으로 이동
                didSendEventClosure?(.moveToOnBoarding)
            default:
                showEdgeToast(message: message)
            }
        }
    }
}

// MARK: - Extension
extension SettingViewController {
    enum Event {
        case moveToUserSetting
        case moveToOnBoarding
    }
}
