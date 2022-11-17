//
//  User.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 17/11/2022.
//

import Foundation

// Expected json object
//{
//        "id": "1",
//        "name": "Tess Fowler",
//        "submittedAt": "2022-03-23T16:12:00.000Z"
//    }

struct User: Decodable {
    
    // TODO
//    var content: String?
    var id, name, submittedAt: String    
}
