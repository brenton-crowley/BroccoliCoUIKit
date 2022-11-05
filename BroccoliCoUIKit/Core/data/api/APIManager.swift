//
//  APIManager.swift
//  BroccoliCoUIKit
//
//  Created by Brent Crowley on 5/11/2022.
//

import Foundation

enum APIError: LocalizedError {
    
    case invalidURL
    case noData
    case invalidResponseCode(received: Int, expected: Int = 200, data: Data? = nil)
    
}

protocol APIManageable {
    
    var urlSession: URLSession { get }
    
    func performRequest(_ request: Requestable, expectedResponseCode: Int) async throws -> Data?
    func parseJSONData<T: Decodable>(_ data: Data, type: T.Type) throws -> T?
}

extension APIManageable {
    
    var urlSession: URLSession { URLSession.shared }
    
    func performRequest(_ request: Requestable, expectedResponseCode: Int = 200) async throws -> Data? {
        
        let urlRequest = try request.makeURLRequest()
        
        let (data, response): (Data, URLResponse) = try await urlSession.data(for: urlRequest)
        
        let code = (response as? HTTPURLResponse)?.statusCode
        guard code == expectedResponseCode else { throw APIError.invalidResponseCode(received: code ?? -1, data: data) }
        
        return data
    }
    
    func parseJSONData<T: Decodable>(_ data: Data, type: T.Type) throws -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
    
}
