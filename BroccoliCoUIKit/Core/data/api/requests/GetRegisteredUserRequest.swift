//
//  GetRegisteredUserRequest.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 17/11/2022.
//

import Foundation

struct GetRegisteredUserRequest: Requestable {
    
    
    var path: String { "/fakeUserList" }
    var requestMethod: RequestMethod = .GET
    
}
