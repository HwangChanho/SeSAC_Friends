//
//  LoginCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/21.
//

import UIKit

protocol LoginCoordinatorDelegate {
    func didLoggedIn(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator, LoginViewControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func moveToVerify() {
        self.delegate?.didLoggedIn(self)
    }
}
