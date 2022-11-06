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
        static let yOffset: CGFloat = 40.0
        static let imageHeightMultiplier: CGFloat = 0.4
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
    
    // MARK: - Initialiser
    required init(celebrationText: String){
        
        self.celebrationText = celebrationText
        
        super.init(frame: CGRect.zero)
        
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constraints
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
            imageView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, multiplier: Constants.imageHeightMultiplier),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.xPadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.xPadding),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ]
        
        return contraints
    }

    private func setupHeader() -> [NSLayoutConstraint] {
        
        addSubview(header)
        
        header.text = celebrationText
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let contraints: [NSLayoutConstraint] = [
            header.bottomAnchor.constraint(lessThanOrEqualTo: self.imageView.topAnchor, constant: -Constants.yOffset),
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        return contraints
    }
    
    private func setupActionButton() -> [NSLayoutConstraint] {
        
        addSubview(actionButton)
        
        actionButton.setTitle("Return home", for: .normal)
        
        let contraints: [NSLayoutConstraint] = [
            actionButton.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: Constants.yOffset),
            actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
        return contraints
    }
}
