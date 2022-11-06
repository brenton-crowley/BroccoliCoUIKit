//
//  TextInputField.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import Foundation

struct TextInputField {
    
    enum Validity {
        case empty, valid, invalid
    }
    
    var nameText: String
    var inputValue: String?
    var placeholderText: String?
    var validity = Validity.empty
    
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

extension TextInputField {
    static let fields: [TextInputField] = [
        TextInputField(
            nameText: "Full name",
            inputValue: nil,
            placeholderText: "Minimum 3 characters"),
        TextInputField(
            nameText: "Email",
            inputValue: nil,
            placeholderText: "master.broc@broccoli.co"),
        TextInputField(
            nameText: "Confirm email",
            inputValue: nil,
            placeholderText: "Same email as above"),
    ]
}
