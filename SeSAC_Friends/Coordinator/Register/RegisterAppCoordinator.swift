//
//  AppCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import UIKit

extension AppCoordinator: RegisterCoordinatorDelegate {
    // MARK: - Nickname VC
    func showNickNameController() {
        let coordinator = RegisterCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func backToLogin(_ coordinator: RegisterCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        UserDefaults.standard.removeObject(forKey: Constants.UserInfo.idToken)
        showOnBoardingViewController()
    }
    
    // MARK: - Main VC
    func submit(_ coordinator: RegisterCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        mainTabBarController()
    }
}
