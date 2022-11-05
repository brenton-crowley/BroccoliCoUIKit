//
//  HomeContent.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 4/11/2022.
//

import Foundation

enum RegisterState: Int {
    
    case unregistered
    case registered
    
    var content: Content {
        
        switch self {
        case .unregistered:
            return Content(heading: "Hello!",
                        description: "Be notified for exclusive access when you enter your name and email.",
                        buttonText: "Enter details")
        case .registered:
            return Content(heading: "Goodbye?",
                        description: "Changed your mind and don't want to stay in the loop? Remove your registeration details below.",
                        buttonText: "Remove details")
        }
        
    }
    
    struct Content {
        var heading, description, buttonText: String
    }
}

extension UserDefaults {
   
    static var registerStateKey = "registerStateKey"
    static var defaultsNameKey = "defaultsNameKey"
    static var defaultsEmailKey = "defaultsEmailKey"
    
    static func readRegisterState() -> RegisterState {
        
        let defaults = UserDefaults.standard
        let intValue = defaults.integer(forKey: UserDefaults.registerStateKey)
        
        return RegisterState(rawValue: intValue) ?? .unregistered
        
    }
    
    static func setRegisterState(newRegisterState: RegisterState) {
        let defaults = UserDefaults.standard
        defaults.setValue(newRegisterState.rawValue, forKey: UserDefaults.registerStateKey)
    }
    
}
