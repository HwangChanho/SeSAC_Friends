//
//  MainCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    // func start()
}

class AppCoordinator: Coordinator, LoginCoordinatorDelegate, MainCoordinatorDelegate, OnBoardingCoordinatorDelegate {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController!
    var window: UIWindow?
    
    init(presenter: UINavigationController) {
        self.navigationController = presenter
        self.childCoordinators = []
    }
    
    // 시작
    func start() {
        if UserDefaults.standard.string(forKey: Constants.UserInfo.idToken) != nil {
            showLoginViewController(false)
        } else {
            showOnBoardingViewController()
        }
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
        self.showLoginViewController(false)
    }
    
    func startButtonPressed(_ coordinator: MainCoordinator) {
        // 회원가입 화면으로 이동
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showNickNameController()
    }
    
    // MARK: - PhoneNumber VC
    func showLoginViewController(_ flag: Bool) {
        // 핸드폰 인증이 된 경우
        if UserDefaults.standard.string(forKey: Constants.UserInfo.idToken) != nil {
            // login 기록이 있을경우
            if (UserDefaults.standard.string(forKey: Constants.UserInfo.userID) != nil) {
                // main으로 이동
                mainTabBarController()
            } else {
                // 회원가입 진행
                showNickNameController()
            }
        } else { // 핸드폰 인증이 안 된경우
            // 첫 로그인
            if UserDefaults.standard.string(forKey: Constants.isFirstLoggin) == nil {
                showOnBoardingViewController()
            } else {
                let coordinator = LoginCoordinator(navigationController: self.navigationController)
                
                coordinator.delegate = self
                coordinator.start()
                
                self.childCoordinators.append(coordinator)
            }
        }
    }
    
    func didLoggedIn(_ coordinator: LoginCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMainViewController()
    }
    
    // MARK: - Onboarding VC
    func showOnBoardingViewController() {
        let coordinator = OnBoardingCoordinator(navigationController: self.navigationController)
        
        coordinator.delegate = self
        coordinator.start()
        
        self.childCoordinators.append(coordinator)
    }
    
    func didStart(_ coordinator: OnBoardingCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showLoginViewController(false)
    }
    
    // MARK: - Move To MainView
    func moveToMain(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.mainTabBarController()
    }
}









