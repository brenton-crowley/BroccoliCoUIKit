//
//  HomeContent.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import Foundation

enum RegisterState {
    
    case unregistered
    case registered(name: String)
    
    var content: Content {
        
        switch self {
        case .unregistered:
            return Content(heading: "Hello!",
                           description: "Be notified for exclusive access when you enter your name and email.",
                           buttonText: "Enter details")
        case .registered(let name):
            return Content(heading: "Hi \(name)!",
                           description: "You're already in the loop for pre-release. If you would like to opt-out, remove your details below.",
                           buttonText: "Remove details")
        }
        
    }
    
    struct Content {
        var heading, description, buttonText: String
    }
}

extension UserDefaults {
    
    static var defaultsNameKey = "defaultsNameKey"
    static var defaultsEmailKey = "defaultsEmailKey"
    
    static func readRegisterState() -> RegisterState {
        
        let defaults = UserDefaults.standard
        if let nameValue = defaults.string(forKey: UserDefaults.defaultsNameKey),
           nameValue.count > 0,
           let emailValue = defaults.string(forKey: UserDefaults.defaultsEmailKey),
           emailValue.count > 0 {
            print("Registered name: \(nameValue) and email \(emailValue)")
            return .registered(name: nameValue)
        }
        
        return .unregistered
        
    }
    
    static func setRegisteredDetails(name: String?, email: String?) {
        let defaults = UserDefaults.standard
        defaults.setValue(name, forKey: UserDefaults.defaultsNameKey)
        defaults.setValue(email, forKey: UserDefaults.defaultsEmailKey)
    }
    
}
