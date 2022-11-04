//
//  HomeViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

class HomeViewController: UIViewController, RequestButtonDelegate {
    
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
    
    // MARK: - RequestButtonDelegate
    func enterDetails() {
        print("Enter details...")
    }
    
    func deregisterDetails() {
        print("Deregister details...")
    }
}
