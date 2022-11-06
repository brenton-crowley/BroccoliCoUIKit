//
//  HomeViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

class HomeViewController: UIViewController, RequestButtonDelegate, RegisterFormViewControllerDelegate, CelebrationViewDelegate {
    
    private struct Constants {
        static let xOffset:CGFloat = 20.0
    }
    
    private var homeView: HomeView = {
        var homeView = HomeView(registerState: UserDefaults.readRegisterState())
        
        return homeView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .themeBackground
        
        setupHomeView()
    }
    
    private func setupHomeView() {
        
        homeView.setDelegate(delegate: self)
        
        self.view.addSubview(homeView)

        homeView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            homeView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            homeView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            homeView.topAnchor.constraint(equalTo: self.view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func updateHomeView() {
        homeView.registerState = UserDefaults.readRegisterState()
        
        
    }
    
    // MARK: - RequestButtonDelegate
    func enterDetails() {
        
        // present the modal to enter details
        let registerFormViewController = RegisterFormViewController()
        registerFormViewController.delegate = self
        
        present(registerFormViewController, animated: true)
    }
    
    func deregisterDetails() {
        UserDefaults.setRegisteredDetails(name: nil, email: nil)
        
        // present the congratulations view
        let confirmationViewController = CelebrationViewController()
        confirmationViewController.celebrationMessage = "Details removed."
        confirmationViewController.modalPresentationStyle = .fullScreen
        confirmationViewController.delegate = self
        present(confirmationViewController, animated: true)
    }
    
    // MARK: - RegisterFormViewController Delegate
    func dismissRegisterFormViewController() {
        dismiss(animated: true)
        updateHomeView()
    }
    
    // MARK: - CelebrationViewController Delegate
    func dismissCelebrationViewController() {
        dismiss(animated: true)
        updateHomeView()    
    }
}
