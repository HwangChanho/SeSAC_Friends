//
//  MainCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

class AppCoordinator: Coordinator, LoginCoordinatorDelegate, MainCoordinatorDelegate, OnBoardingCoordinatorDelegate {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(presenter: UINavigationController) {
        self.navigationController = presenter
        self.childCoordinators = []
    }
    
    func start() {
        showOnBoardingViewController()
        // showMainViewController()
//        if !UserDefaults.isfirstLogin {
//            showOnBoardingViewController()
//            UserDefaults.standard.set(true, forKey: Constants.isFirstLoggin)
//        } else {
//
//        }
    }
    
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    private func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    private func showOnBoardingViewController() {
        let coordinator = OnBoardingCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func backButtonPressed(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
    
    func startButtonPressed(_ coordinator: MainCoordinator) {
        
    }
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
    
    func didStart(_ coordinator: OnBoardingCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
    
}







