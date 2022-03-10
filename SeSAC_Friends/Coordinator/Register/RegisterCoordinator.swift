//
//  RegisterCoordinator.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/26.
//

import UIKit

protocol RegisterCoordinatorDelegate {
    func backToLogin(_ coordinator: RegisterCoordinator)
    func submit(_ coordinator: RegisterCoordinator)
}

class RegisterCoordinator: Coordinator, NicknameControllerDelegate, BirthControllerDelegate, EmailControllerDelegate, GenderControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var delegate: RegisterCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    private var inValidNickname: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("RegisterCoordinator deinit")
    }
    
    // nickname VC
    func start() {
        moveToGender()
        
        if inValidNickname {
            inValidNickname = false
            let viewController = NicknameViewController()
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToLoginAppCoordinator))
            viewController.navigationItem.leftBarButtonItem?.tintColor = .black
            viewController.inValidID = false
            
            viewController.delegate = self
            viewController.nicknameView.middleView.textField.text = viewController.viewModel.nickName.value
            
            self.navigationController.viewControllers = [viewController]
        } else {
            // 닉네임 오류로인한 리턴
            let viewController = NicknameViewController()
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToLoginAppCoordinator))
            viewController.navigationItem.leftBarButtonItem?.tintColor = .black
            viewController.inValidID = true
            
            viewController.delegate = self
            viewController.nicknameView.middleView.textField.text = viewController.viewModel.nickName.value
            
            self.navigationController.viewControllers = [viewController]
        }
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
        // 메인화면 이동
        self.delegate?.submit(self)
    }
    
    func backToLogin() {
        self.delegate?.backToLogin(self)
    }
    
    func backToNickname() {
        inValidNickname = true
        start()
    }
}

/* Button Action */
extension RegisterCoordinator {
    @objc func backToLoginAppCoordinator() {
        self.backToLogin()
    }
    
    @objc func backToNickName() {
        start()
    }
    
    @objc func backToBirth() {
        moveToBirth()
    }
    
    @objc func backToEmail() {
        moveToEmail()
    }
}
