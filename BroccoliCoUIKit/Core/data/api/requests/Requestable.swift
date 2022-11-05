//
//  Requestable.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import Foundation

enum RequestMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

protocol Requestable {
    
    // URLComponents
    var scheme: String { get }
    var host: String { get }
    var version: String { get }
    var path: String { get }
    
    var headers: [String: String] { get }
    var bodyParams: [String: Any] { get }
    
    // HTTP Method
    var requestMethod: RequestMethod { get }
}

// default implementation
extension Requestable {
    
    // url
    var scheme: String { "https" }
    var host: String { "us-central1-blinkapp-684c1.cloudfunctions.net" }
    var version: String { "" }
    var requestMethod: RequestMethod { .POST }
    var path: String { "/fakeAuth" }
    
    var headers: [String: String] { [:] }
    var bodyParams: [String: Any] { [:] }
    
    func makeURLRequest() throws -> URLRequest {
        
        guard let url = makeURLComponents().url else { throw APIError.invalidURL}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = requestMethod.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !bodyParams.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: bodyParams, options: [])
          }
        
        return urlRequest
    }
    
    private func makeURLComponents() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = version + path
        
        return components
    }
    
    
}
