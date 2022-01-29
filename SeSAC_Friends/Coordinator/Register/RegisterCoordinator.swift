//
//  RegisterCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import UIKit

protocol RegisterCoordinatorDelegate {
    func backToLogin(_ coordinator: RegisterCoordinator)
}

class RegisterCoordinator: Coordinator, NicknameControllerDelegate, BirthControllerDelegate, EmailControllerDelegate, GenderControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var delegate: RegisterCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // nickname VC
    func start() {
        
        moveToGender()
//        let viewController = NicknameViewController()
//
//        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToLoginAppCoordinator))
//        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
//
//        viewController.delegate = self
//        viewController.nicknameView.middleView.textField.text = viewController.viewModel.nickName.value
//
//        self.navigationController.viewControllers = [viewController]
    }
    
    func moveToBirth() {
        let viewController = BirthViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToNickName))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
      
    func moveToEmail() {
        let viewController = EmailViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToBirth))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func moveToGender() {
        let viewController = GenderViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToEmail))
        viewController.navigationItem.leftBarButtonItem?.tintColor = .black
        
        viewController.delegate = self
        
        self.navigationController.viewControllers = [viewController]
    }
    
    func submit() {
        
    }
    
    func backToLogin() {
        self.delegate?.backToLogin(self)
    }
    
    func backToNickname() {
        start()
    }
}

/* Button Action */
extension RegisterCoordinator {
    @objc func backToLoginAppCoordinator() {
        self.backToLogin()
    }
    
    @objc func backToNickName() {
        backToNickname()
    }
    
    @objc func backToBirth() {
        moveToBirth()
    }
    
    @objc func backToEmail() {
        moveToEmail()
    }
}
