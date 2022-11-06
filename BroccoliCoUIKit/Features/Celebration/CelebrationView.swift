//
//  CelebrationView.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 6/11/2022.
//

import UIKit

class CelebrationView: UIView {
    
    private struct Constants {
        
        static let xPadding: CGFloat = 20.0
        static let yOffset: CGFloat = 50.0
        
    }

    private var imageView: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "celebration")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var header: UILabel = {
        var label = UILabel()
        label.textColor = .themeForeground
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private(set) var actionButton: UIButton = {
        return UIButton.makeActionButton()
    }()
    
    private var celebrationText: String
    
    required init(celebrationText: String){
        
        self.celebrationText = celebrationText
        
        super.init(frame: CGRect.zero)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .themeBackground
        
        NSLayoutConstraint.activate(
            setupImage() +
            setupHeader() +
            setupActionButton()
        )
    }
    
    private func setupImage() -> [NSLayoutConstraint] {
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let contraints: [NSLayoutConstraint] = [
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.xPadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.xPadding),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        return contraints
    }

    private func setupHeader() -> [NSLayoutConstraint] {
        
        addSubview(header)
        
        header.text = celebrationText
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let contraints: [NSLayoutConstraint] = [
            header.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -Constants.yOffset),
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        return contraints
    }
    
    private func setupActionButton() -> [NSLayoutConstraint] {
        
        addSubview(actionButton)
        
        actionButton.setTitle("Return home", for: .normal)
//        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        let contraints: [NSLayoutConstraint] = [
            actionButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.yOffset),
            actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        return contraints
    }
}
