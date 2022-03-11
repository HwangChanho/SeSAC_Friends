//
//  CardView.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/04.
//

import UIKit
import SnapKit
import RxSwift

final class CardView: UIView {
    // MARK: - Properties
    let imageView = UIImageView()
    let sesacImage = UIImageView()

    let cardView = UIStackView()
    
    let topView = UIView()
    let name = UILabel()
    let button = UIButton()
    
    let middleView = UIView()
    let titleInfoLabel = UILabel()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.identifier)
        
        return cv
    }()
    
    let bottomView = UIView()
    let reviewInfoLabel = UILabel()
    let textField = UITextView()
    let reviewButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .slpBlack
        
        return button
    }()
    
    var cardFlag = true
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var buttonTapActionHandler: (() -> Void)?
    var reviewButtonTapActionHandler: (() -> Void)?
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
        bindButton()
        bindTextField()
        
        collectionView.delegate = self
        
        hideView(cardFlag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        print(#function)
    }
    
    deinit {
        print("Deinit : CardView")
        disposeBag = DisposeBag()
    }
    
    // MARK: - Methods
    func bindButton() {
        button.rx.tap
            .bind { [self] _ in
                cardFlag.toggle()
                hideView(cardFlag)
            }
            .disposed(by: disposeBag)
        
        reviewButton.rx.tap
            .bind { [self] _ in
                reviewButtonTapActionHandler?()
            }
            .disposed(by: disposeBag)
    }
    
    func bindTextField() {
        textField.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .subscribe (onNext: { [self] _ in
                textField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    func hideView(_ value: Bool) {
        [middleView, bottomView].forEach {
            $0.isHidden = value
        }
        
        if value {
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
    }
    
    func setupView() {
        [topView, middleView, bottomView].forEach {
            $0.backgroundColor = .clear
        }
        
        imageView.image = UIImage(named: "sesac_background1")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        sesacImage.image = UIImage(named: "sesac_face0")
        sesacImage.clipsToBounds = true
        
        name.text = "Default User"
        name.font = UIFont(name: UIFont.NSBold, size: 16)
        name.textColor = .slpBlack
        name.numberOfLines = 0
        
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .slpGray7
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cardView.backgroundColor = .clear
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.slpGray2.cgColor
        
        cardView.axis = .vertical
        cardView.distribution = .fill
        cardView.clipsToBounds = true
        
        titleInfoLabel.text = "새싹 타이틀"
        titleInfoLabel.font = UIFont(name: UIFont.NSRegular, size: 12)
        titleInfoLabel.numberOfLines = 0
        titleInfoLabel.textColor = .slpBlack
        
        reviewInfoLabel.text = "새싹 리뷰"
        reviewInfoLabel.font = UIFont(name: UIFont.NSRegular, size: 12)
        reviewInfoLabel.numberOfLines = 0
        reviewInfoLabel.textColor = .slpBlack
        
        textField.text = "첫 리뷰를 기다리는 중이에요!"
        textField.font = UIFont(name: UIFont.NSRegular, size: 14)
        textField.textColor = .slpBlack
        textField.tintColor = .slpGray7
        textField.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textField.isScrollEnabled = false
        textField.isEditable = false
    }
    
    func setupConstraints() {
        [imageView, sesacImage, cardView].forEach {
            addSubview($0)
        }
        
        [topView, middleView, bottomView].forEach {
            cardView.addArrangedSubview($0)
        }
        
        [name, button].forEach {
            topView.addSubview($0)
        }
        
        [titleInfoLabel, collectionView].forEach {
            middleView.addSubview($0)
        }
        
        [reviewInfoLabel, textField, reviewButton].forEach {
            bottomView.addSubview($0)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(194)
        }
        
        sesacImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(184)
            make.bottom.equalTo(imageView.snp.bottom).offset(10)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // MARK: - For CardView(StackView)
        name.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalTo(button.snp.left).offset(-10)
            make.height.equalTo(26)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(name.snp.right).offset(10)
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
        reviewInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(reviewInfoLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.right.equalTo(self.snp.right).offset(-30)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(12)
            make.width.equalTo(6)
        }
    }
    
    func remakeTextField() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
    }
}

// MARK: - UICollectionViewDelegate, TextFieldDelegate
extension CardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - @objc Methods
extension CardView {
    @objc func buttonTapped(_ sender: UIButton) {
        buttonTapActionHandler?()
    }
}
