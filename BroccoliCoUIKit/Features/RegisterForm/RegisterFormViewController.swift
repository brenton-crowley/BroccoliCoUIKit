//
//  RegisterFormViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

protocol FormField: AnyObject {

    var height: CGFloat { get }

    func register(for tableView: UITableView)
    func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

class RegisterFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TextInputCellDelegate {
    
    private struct Constants {
        static let buttonHeight:CGFloat = 50.0
        static let xOffset:CGFloat = 20.0
    }
    
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var sendButton = UIButton()
    private var observer: NSObjectProtocol?
    
    var fields: [TextInputField] = [
        TextInputField(
            nameText: "Full name",
            inputValue: nil,
            placeholderText: "Minimum 3 characters"),
        TextInputField(
            nameText: "Email",
            inputValue: nil,
            placeholderText: "master.broc@broccoli.co"),
        TextInputField(
            nameText: "Confirm email",
            inputValue: nil,
            placeholderText: "Same email as above"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NSLayoutConstraint.activate(
            setupTableView() +
            setupButton()
        )
    }
    
    private func didUpdateModel() {
        print("did update model")
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func setupTableView() -> [NSLayoutConstraint] {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TextInputCell.self, forCellReuseIdentifier: "TextInputCell")
        tableView.backgroundColor = .themeBackground
        
        self.view.addSubview(tableView)
        
        // add constraints
        let constaints: [NSLayoutConstraint] = [
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonHeight)
        ]
        
        return constaints
    }
    
    private func setupButton() -> [NSLayoutConstraint] {
        
        var config = UIButton.Configuration.filled()
        config.buttonSize = .large
        config.cornerStyle = .capsule
        
        sendButton.configuration = config
        sendButton.tintColor = .themeAccent
        sendButton.setTitle("Register my details", for: .normal)

        sendButton.addTarget(self, action: #selector(registerDetailsTapped), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(sendButton)
        
        let constaints: [NSLayoutConstraint] = [
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonHeight - Constants.xOffset),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.xOffset),
            sendButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.xOffset),
        ]
        
        return constaints
        
    }
    
    // MARK: - Send Button Target Action
    @objc private func registerDetailsTapped() {
        print("Register details - kickstart call to back end.")
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.buttonHeight
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
        cell.configure(textInputField: fields[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    // MARK: - TextInputCell Delegate
    func cell(_ cell: TextInputCell, didChangeValue value: String?) {
        // update model and invalidate view
        if let cellID = cell.cellID,
           let cellIndex = fields.firstIndex(where: { $0.nameText == cellID }) {
            fields[cellIndex].inputValue = value
        }
    }
}
