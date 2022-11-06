//
//  CelebrationViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 6/11/2022.
//

import UIKit

protocol CelebrationViewDelegate: AnyObject {
    func dismissCelebrationViewController()
}

class CelebrationViewController: UIViewController {

    var celebrationMessage: String?
    
    weak var delegate: CelebrationViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let celebrationView = CelebrationView(celebrationText: celebrationMessage ?? "Woohoo!")
        
        self.view.addSubview(celebrationView)
        
        celebrationView.translatesAutoresizingMaskIntoConstraints = false
        
        celebrationView.actionButton.addTarget(self, action: #selector(celegrationViewActionButtonTapped), for: .touchUpInside)
        
        let constraints: [NSLayoutConstraint] = celebrationView.constraintsForAnchoringTo(boundsOf: self.view)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func celegrationViewActionButtonTapped() {
        print("celegrationViewActionButtonTapped")
        self.delegate?.dismissCelebrationViewController()
    }
}
