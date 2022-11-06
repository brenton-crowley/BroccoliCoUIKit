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
        static let cellReuseIdentifier = "TextInputCell"
    }
    
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var sendButton = UIButton.makeActionButton()
    
    weak var delegate: RegisterFormViewControllerDelegate?
    
    var fields: [TextInputField] = TextInputField.fields

    var nameField: TextInputField { fields[0] }
    var emailField: TextInputField { fields[1] }
    var confirmField: TextInputField { fields[2] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .themeBackground
        
        // Do any additional setup after loading the view.
        NSLayoutConstraint.activate(
            setupTableView() +
            setupButton()
        )
    }
    
    // MARK: - Setup Constraints
    func setupTableView() -> [NSLayoutConstraint] {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TextInputCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
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
    
    // MARK: - Send Button Target Action & API Call
    @objc private func registerDetailsTapped() {
        
        tableView.reloadData()
        
        guard isValidForm() else { return }
        
        // change button image and text to progressing
        sendButton.isEnabled = false
        sendButton.activityIndicatorEnabled = true
        self.isModalInPresentation = true // so that user cannot lose their submission while waiting
        
        // Kick off an asyn task to send the email and name to the API
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
            
            // re-enable the button after success or failure
            DispatchQueue.main.async {
                self.isModalInPresentation = false
                self.sendButton.isEnabled = true
                self.sendButton.activityIndicatorEnabled = false
            }
        }
    }
    
    private func sendDetailsToEndpoint() async throws {
        let name = nameField.inputValue ?? ""
        let email = emailField.inputValue ?? ""
        
        let request = PostRegistationRequest(name: name, email: email)
        
        guard let response = try await performRequest(request) else { throw APIError.noData }
        
        print(response)
    }
    
    // MARK: - Form Validation
    @discardableResult
    private func isValidForm() -> Bool {
        
        // set explicitly becaus structs
        fields[0].validity = nameField.isMinimumCharLength() ? .valid : .invalid
        fields[1].validity = emailField.isValidEmailFormat() ? .valid : .invalid
        fields[2].validity = confirmField.matchesFieldValue(emailField.inputValue ?? "") ? .valid : .invalid
        
        return fields.allSatisfy { $0.validity == .valid }
    }
    
    // MARK: - Alerts
    private func presentSuccessAlert() async {
        
        writeToUserDefaults()

        let alert = UIAlertController.Network.success.makeAlert
        
        // Add OK action that presents a celebration view upon action taken.
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
        
        let alert = UIAlertController.Network.failure(message: message.errorMessage).makeAlert
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async { self.present(alert, animated: true) }
    }
    
    // MARK: - UserDefaults Helper
    private func writeToUserDefaults() {
        // Since the call was successul, write to user defaults.
        if let name = nameField.inputValue,
           let email = emailField.inputValue {
            UserDefaults.setRegisteredDetails(name: name, email: email)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! TextInputCell
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

        dismiss(animated: true)
        
        switch UserDefaults.readRegisterState() {
        case .registered(_):
            self.delegate?.dismissRegisterFormViewController()
        default:
            break
        }
    }
}
