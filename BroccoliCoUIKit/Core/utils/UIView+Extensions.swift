//
//  UIView+Extensions.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import Foundation
import UIKit

extension UIView {

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
    }
    
    /// Returns a collection of constraints to match the center x and center y of the supplied view
    ///
    /// - Parameter view: The view to match center x and center y to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForMatchingCenterXYOfView(_ view: UIView) -> [NSLayoutConstraint] {
        let constraints:[NSLayoutConstraint] = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        
        return constraints
    }
}
