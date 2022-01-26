//
//  MainCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

protocol MainCoordinatorDelegate {
    func backButtonPressed(_ coordinator: MainCoordinator)
    func startButtonPressed(_ coordinator: MainCoordinator)
}

class MainCoordinator: Coordinator, VerifyViewControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var delegate: MainCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = VerifyViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonDidTap))

        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        // Timer On
        viewController.verifyView.middleView.textField.setTimer(timeMin: 1, timeSec: 0, color: .slpGreen)
        viewController.verifyView.middleView.textField.timerOn()
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func didBackButtonTapped() {
        self.delegate?.backButtonPressed(self)
    }
    
    func didNextButtonTapped() {
        self.delegate?.startButtonPressed(self)
    }
}

extension MainCoordinator {
    @objc func backButtonDidTap() {
        didBackButtonTapped()
    }
}
