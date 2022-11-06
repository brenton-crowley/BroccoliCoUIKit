//
//  RegisterFormViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

protocol RegisterFormViewControllerDelegate: AnyObject {
    
    func dismissRegisterFormViewController()
}

class RegisterFormViewController: UIViewController,
                                  UITableViewDelegate,
                                  UITableViewDataSource,
                                  TextInputCellDelegate,
                                  CelebrationViewDelegate,
                                  APIManageable {
    
    private struct Constants {
        static let buttonHeight:CGFloat = 50.0
        static let xOffset:CGFloat = 20.0
    }
    
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var sendButton = UIButton()
    private var observer: NSObjectProtocol?
    
    weak var delegate: RegisterFormViewControllerDelegate?
    
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
        
        self.view.backgroundColor = .themeBackground
        
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
        sendButton.setTitle("Making it happen...", for: .disabled)
        
        sendButton.activityIndicatorColor = .themeForeground
        
        sendButton.addTarget(self, action: #selector(registerDetailsTapped), for: .touchUpInside)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(sendButton)
        
        let constaints: [NSLayoutConstraint] = [
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonHeight),
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.xOffset),
            sendButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.xOffset),
        ]
        
        return constaints
        
    }
    
    // MARK: - Send Button Target Action
    @objc private func registerDetailsTapped() {
        
        tableView.reloadData()
        
        guard isValidForm() else { return }
        
        // change button image and text to progressing
        sendButton.isEnabled = false
        sendButton.activityIndicatorEnabled = true
        
        Task {
            do {
                try await sendDetailsToEndpoint()
                await self.presentSuccessAlert()
            } catch {
                switch error as? APIError {
                case .invalidResponseCode(_, _, let data):
                    var errorMessage: ErrorMessage?
                    if let data = data {
                        errorMessage = try self.parseJSONData(data, type: ErrorMessage.self)
                    }
                    await self.presentFailureAlertWithMessage(errorMessage)
                default:
                    print(error)
                }
            }
            
            // re-enable the button
            DispatchQueue.main.async {
                self.sendButton.isEnabled = true
                self.sendButton.activityIndicatorEnabled = false
            }
        }
    }
    
    @discardableResult
    private func isValidForm() -> Bool {
        
        // valid

        fields[0].validity = fields[0].isMinimumCharLength() ? .valid : .invalid
        fields[1].validity = fields[1].isValidEmailFormat() ? .valid : .invalid
        fields[2].validity = fields[2].matchesFieldValue(fields[1].inputValue ?? "") ? .valid : .invalid
        
        return fields.allSatisfy { field in
            field.validity == .valid
        }
    }
    
    private func sendDetailsToEndpoint() async throws {
        let name = fields[0].inputValue ?? "Test name"
        let email = fields[1].inputValue ?? "name2@example.com"
        
        let request = PostRegistationRequest(name: name, email: email)
        
        guard let response = try await performRequest(request) else { throw APIError.noData }
        
        print(response)
    }
    
    private func presentSuccessAlert() async {
        let alert = UIAlertController(
            title: "Success!",
            message: "Your details were successfully registered.",
            preferredStyle: .alert)
        
        
        if let name = fields[0].inputValue,
           let email = fields[1].inputValue {
            UserDefaults.setRegisteredDetails(name: name, email: email)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
            // present the celebration view
            DispatchQueue.main.async {
                let celebration = CelebrationViewController()
                celebration.celebrationMessage = "Woot, you're in!"
                celebration.delegate = self
                celebration.modalPresentationStyle = .fullScreen
                self.present(celebration, animated: true)
            }
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func presentFailureAlertWithMessage(_ errorMessage: ErrorMessage? = nil) async {
        
        var message: ErrorMessage
        if  errorMessage != nil {
            message = errorMessage!
        } else {
            message = ErrorMessage(errorMessage: "Unable to register your details.")
        }
        
        let alert = UIAlertController(
            title: "Server Error",
            message: "\(message.errorMessage)",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true) {
                // dismiss entire view controller
            }
        }
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
    
    func cell(_ cell: TextInputCell, didEndEditing value: String?) {
//        isValidForm()
    }
    
    // MARK: - CelebrationView Delegate
    func dismissCelebrationViewController() {
        print("dismiss celebration view controller and dismiss this view controller")
        dismiss(animated: true)
        
        switch UserDefaults.readRegisterState() {
        case .registered(_):
            self.delegate?.dismissRegisterFormViewController()
        default:
            break
        }
    }
}
