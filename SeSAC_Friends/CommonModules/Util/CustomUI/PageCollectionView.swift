//
//  PageCollectionVIew.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import UIKit
import SnapKit
// ??
// MARK: - Custom Cell
class onBoardImageCell: UICollectionViewCell {
    let label = UILabel()
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Deinit : onBoardImageCell")
    }
    
    private func setupView() {
        [label, image].forEach {
            addSubview($0)
        }
        
        //image.contentMode = .scaleAspectFit
        
        label.textColor = .slpBlack
        label.numberOfLines = 2
        label.font = UIFont(name: UIFont.NSRegular, size: 24)
        label.textAlignment = .center
        
        label.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.frame.height / 4)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Custom CollectionView

class PageControlCollectionView: UICollectionView {
    
    static var numberOfPages = 3
    let pageContorl = UIPageControl()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setPageControl()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPageControl() {
        pageContorl.hidesForSinglePage = true
        pageContorl.numberOfPages = PageControlCollectionView.numberOfPages
        pageContorl.pageIndicatorTintColor = .slpGray5
    }
    
    func setConstraint() {
        pageContorl.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
        }
    }
}
