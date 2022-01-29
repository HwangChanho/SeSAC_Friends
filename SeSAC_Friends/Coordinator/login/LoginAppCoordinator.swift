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
    
    var navigationController: UINavigationController!
    
    init(presenter: UINavigationController) {
        self.navigationController = presenter
        self.childCoordinators = []
    }
    // 시작
    func start() {
        showNickNameController()
//        print(!UserDefaults.isfirstLogin)
//
//        if !UserDefaults.isfirstLogin {
//            showOnBoardingViewController()
//            UserDefaults.standard.set(true, forKey: Constants.isFirstLoggin)
//        } else {
//            showLoginViewController()
//        }
    }
    
    // MARK: - Verify VC
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func backButtonPressed(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
    
    func startButtonPressed(_ coordinator: MainCoordinator) {
        // 회원가입 화면으로 이동
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showNickNameController()
    }
    
    // MARK: - PhoneNumber VC
    func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
    
    // MARK: - Onboarding VC
    private func showOnBoardingViewController() {
        let coordinator = OnBoardingCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func didStart(_ coordinator: OnBoardingCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController()
    }
    
}









