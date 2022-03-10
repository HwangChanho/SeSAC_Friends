//
//  reviewCell.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/03/06.
//

import UIKit
import SnapKit

final class ReviewCell: UITableViewCell {
    static let identifier = "ReviewCell"
    
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .slpWhite
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
