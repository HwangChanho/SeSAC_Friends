//
//  SesacFindViewController.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/23.
//

import UIKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy

final class SesacFindViewController: TabmanViewController, NearSesacViewControllerDelegate {
    // MARK: - Properties
    var didSendEventClosure: ((SesacFindViewController.Event) -> Void)?
    
    private let viewModel = HomeViewModel.shared
    private var viewControllers: Array<UIViewController> = []
    
    var disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .slpWhite
        
        let vc = NearSesacViewController()
        let vc2 = RequestedSesacViewController()
        
        vc.delegate = self
        
        viewControllers.append(vc)
        viewControllers.append(vc2)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        bar.buttons.customize { (button) in
            button.tintColor = .slpGray6
            button.selectedTintColor = .slpGreen
        }
        
        bar.indicator.tintColor = .slpGreen
        bar.indicator.overscrollBehavior = .bounce
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    deinit {
        print("Deinit : SesacFindViewController")
    }
    
    // MARK: - Methods
    func backToOnboarding() {
        didSendEventClosure?(.moveToOnboarding)
    }
    
    func backToSesacFind() {
        didSendEventClosure?(.moveToSesacFind)
    }
    
    func moveToReviewDetail(_ review: [String]) {
        let vc = ReviewViewController()
        
        vc.reviews = review
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: vc, action: #selector(vc.backToFind))
        vc.navigationItem.leftBarButtonItem?.tintColor = .black
        vc.navigationItem.title = "새싹 리뷰"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - @objc Methods
extension SesacFindViewController {
    @objc func stopSearching() {
        viewModel.deleteQueue { message, code in
            switch code {
            case .success:
                self.showEdgeToast(message: "찾기 중단")
            case .noUser:
                self.didSendEventClosure?(.moveToOnboarding)
            default:
                self.showEdgeToast(message: message)
            }
        }
    }
}

// MARK: - PageboyViewControllerDataSource, TMBarDataSource
extension SesacFindViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}

// MARK: - Extension
extension SesacFindViewController {
    enum Event {
        case moveToOnboarding
        case backToHome
        case moveToSesacFind
    }
}
