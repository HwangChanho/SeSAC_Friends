//
//  MainCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
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
        
//        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(viewController.backButtonPressed))
//
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func didBackButtonTapped() {
        self.delegate?.didLoggedOut(self)
    }
}
