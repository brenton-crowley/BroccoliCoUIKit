//
//  UIAlertActionController+Extension.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 6/11/2022.
//

import Foundation
import UIKit

extension UIAlertController {
    
    enum Network {
        case success
        case failure(message: String)
        
        var makeAlert: UIAlertController {
            
            switch self {
            case .success:
                return UIAlertController(
                    title: "Success!",
                    message: "Your details were successfully registered.",
                    preferredStyle: .alert)
                
            case .failure(let message):
                return UIAlertController(
                    title: "Server Error",
                    message: "\(message)",
                    preferredStyle: .alert)
            }
            
        }
    }
    
}
