//
//  CelebrationViewController.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 6/11/2022.
//

import UIKit

class CelebrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let celebrationView = CelebrationView(celebrationText: "Woot! You Did It!")
        
        self.view.addSubview(celebrationView)
        
        celebrationView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = celebrationView.constraintsForAnchoringTo(boundsOf: self.view)
        
        NSLayoutConstraint.activate(constraints)
    }
}
