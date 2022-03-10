//
//  MainAppCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/01.
//

import UIKit

extension AppCoordinator: TabBarCoordinatorFinishDelegate {
    // MARK: - Tab Bar
    func mainTabBarController() {
        let coordinator = TabBarCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func backToLogin(_ coordinator: TabBarCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        
        showOnBoardingViewController()
    }
}
