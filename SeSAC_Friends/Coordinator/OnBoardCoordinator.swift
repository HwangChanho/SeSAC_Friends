//
//  OnBoardCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/24.
//

import UIKit

protocol OnBoardingCoordinatorDelegate {
    func didStart(_ coordinator: OnBoardingCoordinator)
}

class OnBoardingCoordinator: Coordinator, OnBoardingControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var delegate: OnBoardingCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = OnBoardingViewController()
        
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func didStart() { // cotroller
        self.delegate?.didStart(self)
    }
}
