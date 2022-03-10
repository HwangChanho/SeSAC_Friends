//
//  HobbyView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/17.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    let label: UILabel = {
        let label = UILabel()
        
        label.textColor = .slpBlack
        label.font = UIFont(name: UIFont.NSRegular, size: 12)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    func setupView() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class HobbyView: UIView, BasicViewSetup {
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let width = self.frame.width
        let height = self.frame.height
        
        // 미리 틀잡기
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        
        cv.register(HobbyViewCell.self, forCellWithReuseIdentifier: HobbyViewCell.identifier)
        
        cv.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        return cv
    }()
    
    let button: UIButton = {
        let button = UIButton()
        
        button.setTitle("새싹 찾기", for: .normal)
        button.tintColor = .slpWhite
        button.backgroundColor = .slpGreen
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: UIFont.NSRegular, size: 14)
        
        return button
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
        print("Deinit : HobbyView")
    }
    
    // MARK: - Methods
    func setupView() {
        collectionView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        [collectionView, button].forEach {
            addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(UIScreen.main.bounds.height - 50)
        }
        
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

// 왼쪽정렬
final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) ->  [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map {
            $0.copy() as! UICollectionViewLayoutAttributes
        }
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else { return }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
