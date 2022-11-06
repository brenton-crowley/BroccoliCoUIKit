//
//  HomeView.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import UIKit

protocol RequestButtonDelegate {
    func enterDetails()
    func deregisterDetails()
}

class HomeView: UIView {
    
    private struct Constants {
        static let bodyTextOpacity:Float = 0.8
        static let bodyNumLines = 4
        static let xOffset:CGFloat = 50.0
        
        static let itemSpacing:CGFloat = 20.0
        static let cornerRadius:CGFloat = 10.0
        
    }
    
    var registerState: RegisterState {
        didSet { updateContent() }
    }
    
    private var delegate: RequestButtonDelegate?
    
    // header
    private var header: UILabel = {
       
        var view = UILabel()
        view.numberOfLines = 0
        view.textColor = .themeForeground
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.adjustsFontForContentSizeCategory = true
        
        return view
    }()
    
    // infoText
    private var info: UILabel = {
       
        var view = UILabel()
        view.textColor = .themeForeground
        view.numberOfLines = Constants.bodyNumLines
        view.layer.opacity = Constants.bodyTextOpacity
        view.textAlignment = .center
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        
        return view
    }()
    
    // requestButton
    private var requestButton = UIButton.makeActionButton()
    
    // MARK: - Initialisers
    
    required init(registerState: RegisterState, delegate: RequestButtonDelegate? = nil){
        self.registerState = registerState
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func setDelegate(delegate: RequestButtonDelegate) { self.delegate = delegate }
    
    private func updateContent() {
        header.text = registerState.content.heading
        info.text = registerState.content.description
        requestButton.setTitle(registerState.content.buttonText, for: .normal)
    }
    
    // MARK: - Define Constraints for Views
    
    private func setupView() {
        NSLayoutConstraint.activate(
            setupInfo() +
            setupHeader() +
            setupRequestButton()
        )
        
        updateContent()
    }
    
    private func setupHeader() -> [NSLayoutConstraint] {
        addSubview(header)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints:[NSLayoutConstraint] = [
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            header.bottomAnchor.constraint(equalTo: self.info.topAnchor, constant: -Constants.itemSpacing)
        ]
        
        return constraints
    }
    
    private func setupInfo() -> [NSLayoutConstraint] {
        addSubview(info)
        
        info.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            info.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.xOffset),
            info.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.xOffset),
            info.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        return constraints
    }
    
    private func setupRequestButton() -> [NSLayoutConstraint] {
        addSubview(requestButton)
        
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        
        requestButton.addTarget(self, action: #selector(self.requestButtonTapped), for: .touchUpInside)
        
        let constraints:[NSLayoutConstraint] = [
            requestButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            requestButton.topAnchor.constraint(equalTo: self.info.bottomAnchor, constant: Constants.itemSpacing),
            requestButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.xOffset),
            requestButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Constants.xOffset)
            
        ]
        
        return constraints
        
    }
    
    // MARK: Target Action for Request Button
    
    @objc func requestButtonTapped() {
        
        switch registerState {
        case .unregistered:
            delegate?.enterDetails()
        case .registered:
            delegate?.deregisterDetails()
        }
        
    }
    
}
