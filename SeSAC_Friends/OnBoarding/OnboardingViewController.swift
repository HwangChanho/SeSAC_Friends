//
//  OnboardingViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import SnapKit
import UIKit
import RxSwift

protocol OnBoardingControllerDelegate {
    func didStart()
}

class OnBoardingViewController: UIViewController {
    // MARK: - Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    let pageControl = UIPageControl()
    let button = UIButton()
    let stackView = UIStackView()
    
    let model = onBoard()
    var delegate: OnBoardingControllerDelegate?
    var disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        bindButton()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - View
    private func setViews() {
        view.backgroundColor = .white
        
        stackView.backgroundColor = .clear
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.register(onBoardImageCell.self, forCellWithReuseIdentifier: "onBoardCell")
        
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .slpGray5
        pageControl.currentPageIndicatorTintColor = .slpBlack
        
        button.defaultButton("시작하기", backGroundColor: .slpGreen, titleColor: .slpWhite)
        
        view.addSubview(stackView)
        
        [collectionView, pageControl, button].forEach { data in
            stackView.addSubview(data)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-1)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-30)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    private func bindButton() {
        button.rx.tap
            .bind {
                self.delegate?.didStart()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate
extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.textArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardCell", for: indexPath) as! onBoardImageCell
        
        cell.label.text = model.textArr[indexPath.row]
        cell.label.setTextColor(color: .slpGreen, text: model.coloredTextArr[indexPath.row])
        cell.image.image = UIImage(named: model.imageArr[indexPath.row]) ?? UIImage(systemName: "star")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(ceil(targetContentOffset.pointee.x / collectionView.frame.width))
        pageControl.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -6
    }
}
