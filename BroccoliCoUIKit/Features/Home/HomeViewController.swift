//
//  HomeViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

class HomeViewController: UIViewController, RequestButtonDelegate, RegisterFormViewControllerDelegate, CelebrationViewDelegate, APIManageable, UITableViewDataSource {
    
    private struct Constants {
        static let xOffset:CGFloat = 20.0
        static let cellReuseIdentifier = "registeredUserCell"
    }
    
    private var homeView: HomeView = {
        var homeView = HomeView(registerState: UserDefaults.readRegisterState())
        
        return homeView
    }()
    
    private var registeredUsers:[User] = []
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var contentView: UIStackView = {
       
        var contentView = UIStackView()
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .themeBackground
        
        // Define constraints and layout views
        NSLayoutConstraint.activate(
            setupContentView() +
            setupHomeView() +
            setupTableView()
        )
        
        // Retrieve list of registered users
        
        retrieveRegisteredUsers()
    }
    
    private func retrieveRegisteredUsers() {
        
        Task {
            do {
                // make request to get users
                let request = GetRegisteredUserRequest()
//                // perform request
                let data = try await self.performRequest(request)
                if let data = data {
                    // parse the response
                    self.registeredUsers = try self.parseJSONData(data, type: [User].self) ?? []
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                
            }
        }

    }
    
    private func setupContentView() -> [NSLayoutConstraint] {
        
        self.view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.distribution = .fillEqually // all that was needed was to change to .fillEqually
        
        return contentView.constraintsForAnchoringTo(boundsOf: self.view)
        
    }
    
    private func setupHomeView() -> [NSLayoutConstraint] {
        
        homeView.setDelegate(delegate: self)
        
//        self.view.addSubview(homeView)
        self.contentView.addArrangedSubview(homeView)

        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.backgroundColor = .red
        
        let constraints: [NSLayoutConstraint] = [
//            homeView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
//            homeView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            homeView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            homeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ]
        
        return constraints
        
    }
    
    func setupTableView() -> [NSLayoutConstraint] {
        
//        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .themeBackground
        tableView.backgroundColor = .blue
        
//        self.view.addSubview(tableView)
        self.contentView.addArrangedSubview(tableView)
        
        // add constraints
        let constaints: [NSLayoutConstraint] = [
//            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        return constaints
    }
    
    private func updateHomeView() {
        homeView.registerState = UserDefaults.readRegisterState()
        
        
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.cellReuseIdentifier)
        var content = cell.defaultContentConfiguration()
        let user = registeredUsers[indexPath.item]
        // Configure content.
        content.text = user.name

        cell.contentConfiguration = content

        return cell
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
