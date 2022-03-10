//
//  ReviewViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/28.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ReviewViewController: UIViewController {
    // MARK: - Properties
    var reviews: [String]?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .slpWhite
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return tableView
    }()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Methods
    func setUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func backToFind() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extension
extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else { return UITableViewCell() }
        
        cell.textView.text = reviews?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
