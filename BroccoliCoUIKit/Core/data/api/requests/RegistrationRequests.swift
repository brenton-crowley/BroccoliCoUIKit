//
//  RegistrationRequests.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import Foundation

struct PostRegistationRequest: Requestable {
    
    let nameKey = "name"
    let emailKey = "email"
    
    var bodyParams: [String : Any] = [:]
    
    init(name: String, email: String) {
        self.bodyParams[nameKey] = name
        self.bodyParams[emailKey] = email
    }
}
