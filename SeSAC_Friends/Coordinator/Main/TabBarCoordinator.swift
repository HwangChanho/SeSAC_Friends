//
//  TabBarCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/02/01.
//

import UIKit

protocol TabBarCoordinatorDelegate: Coordinator {
    var tabBarController: UITabBarController { get set }
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

protocol TabBarCoordinatorFinishDelegate {
    func backToLogin(_ coordinator: TabBarCoordinator)
}

class TabBarCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    
    var delegate: TabBarCoordinatorFinishDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = .init()
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.home, .setting]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({
            getTabController($0)
        })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    // MARK: - UserSetting
    func moveToUserSetting() {
        let viewController = UserSettingViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToSetting))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: viewController, action: #selector(viewController.saveUserInfo))
        viewController.navigationItem.rightBarButtonItem?.tintColor = .black
        
        viewController.navigationItem.title = "정보 관리"
        
        viewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .moveToOnBoarding:
                self?.delegate?.backToLogin(self!)
            case .backToSetting:
                self?.backToSetting()
            }
        }
        
        navigationController.isNavigationBarHidden = false
        //navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers = [viewController]
    }
    
    // MARK: - Hobby
    func moveToHobby() {
        let viewController = HobbyViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToSetting))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .moveToOnboarding:
                self?.delegate?.backToLogin(self!)
            case .backToHome:
                self?.backToSetting()
            case .moveToSesacFind:
                self?.moveToSesacFind()
            }
        }
        
        navigationController.isNavigationBarHidden = false
        //navigationController.pushViewController(viewController, animated: true)
        self.navigationController.viewControllers = [viewController]
    }
    
    // MARK: - SesacFind
    func moveToSesacFind() {
        let viewController = SesacFindViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToSetting))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: viewController, action: #selector(viewController.stopSearching))
        viewController.navigationItem.rightBarButtonItem?.tintColor = .black
        
        viewController.navigationItem.title = "새싹 찾기"
        
        viewController.didSendEventClosure = { [weak self] event in
            switch event {
            case .moveToOnboarding:
                self?.delegate?.backToLogin(self!)
            case .backToHome:
                self?.backToSetting()
            case .moveToSesacFind:
                self?.backToSesacFind()
            }
        }
        
        navigationController.isNavigationBarHidden = false
        self.navigationController.viewControllers = [viewController]
    }
    
    // MARK: - TabBarControl
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        // Set delegate for UITabBarController
        tabBarController.delegate = self
        
        // Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: true)
        
        // Let set index
        tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        
        // Styling
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .slpWhite
        tabBarController.tabBar.tintColor = .slpGreen
        
        // In this step, we attach tabBarController to navigation controller associated with this coordanator
        navigationController.viewControllers = [tabBarController]
        navigationController.isNavigationBarHidden = true // 네비게이션 바 두개됨
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        // 새로운 네비게이션 입력
        
        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageIconImage(),
                                                     tag: page.pageOrderNumber())
        
        // 각자 탭의 controller 내부에서 page 이동
        switch page {
        case .home:
            let homeVC = HomeViewController()
            homeVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .moveToOnboarding:
                    self?.delegate?.backToLogin(self!)
                case .moveToHobby:
                    self?.moveToHobby()
                }
            }
            
            navController.pushViewController(homeVC, animated: true)
            
        case .setting:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let settingVC = SettingViewController()
            
            settingVC.navigationItem.title = page.pageTitleValue()
            
            settingVC.didSendEventClosure = { [weak self] event in
                switch event {
                case .moveToUserSetting:
                    self?.moveToUserSetting()
                case .moveToOnBoarding:
                    self?.delegate?.backToLogin(self!)
                }
            }
            
            navController.pushViewController(settingVC, animated: true)
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        print("selected")
        // Some implementation
    }
}

// MARK: - objcMethods
extension TabBarCoordinator {
    @objc func backToSetting() {
        start()
    }
    
    @objc func backToSesacFind() {
        start()
    }
}


