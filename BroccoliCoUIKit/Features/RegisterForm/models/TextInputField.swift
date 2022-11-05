//
//  TextInputField.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import Foundation

struct TextInputField {
    
    var nameText: String
    var inputValue: String?
    var placeholderText: String?
    
}

extension Notification.Name {
    static let textInputFieldDidChange = Notification.Name("TextInputFieldDidChange")
}

extension TextInputField {
    
    func isMinimumCharLength(_ charLength: Int = 3) -> Bool {
        guard let inputValue else { return false }
        
        return inputValue.trimmingCharacters(in: .whitespacesAndNewlines).count >= charLength
    }
    
    // Code Snippet From: https://www.advancedswift.com/regular-expressions/#email-regular-expression
    func isValidEmailFormat() -> Bool {
        
        guard let inputValue else { return false }
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        let result = inputValue.range(
            of: emailPattern,
            options: .regularExpression
        )

        return (result != nil)
    }
    
    func matchesFieldValue(_ value: String) -> Bool {
        
        guard let inputValue else { return false }
        
        return inputValue == value
    }
}
