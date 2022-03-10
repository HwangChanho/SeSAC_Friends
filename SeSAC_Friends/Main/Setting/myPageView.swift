//
//  myPageView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/03.
//

import UIKit
import SnapKit

final class MyPageView: UIView, BasicViewSetup {
    // MARK: - Properties
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let topView = CardView()
    let bottomView = MyPageBottomView()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        
        backgroundColor = .slpWhite
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : MyPageView")
    }
    
    // MARK: - Methods
    func setupView() {
        scrollView.backgroundColor = .clear
        topView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [topView, bottomView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(contentView.snp.width)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(contentView.snp.width)
        }
    }
        
}
