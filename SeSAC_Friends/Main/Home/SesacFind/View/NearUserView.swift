//
//  NearUserView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/26.
//

import UIKit
import SnapKit

final class NearUserView: UIView, BasicViewSetup {
    // MARK: - Properties
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped) 
    
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private var keyHeight: CGFloat? // 키보드 높이 저장
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .slpWhite
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : NearUserView")
    }
    
    // MARK: - Methods
    func setupView() {
        tableView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(-30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
