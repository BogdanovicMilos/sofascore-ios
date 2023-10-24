//
//  APIRequest.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

struct APIRequest<T: Decodable>: NetworkRequest {
    
    typealias Response = T
    
    // MARK: - Properties
    
    var baseURL: URL?
    var path: String
    var type: RequestType
    var headers: [HTTPHeaderType: String]
    var bodyParameters: Encodable?
    var queryParameters: [String: CustomStringConvertible]?
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .formatted([.rfc3339, .rfc3339WithoutMilliseconds])
        return decoder
    }
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
//        encoder.dateEncodingStrategy = .formatted(.rfc3339)
        return encoder
    }
    
    // MARK: - Initializers
    
    init(baseURL: URL? = Constants.apiBaseURL,
         path: String,
         type: RequestType,
         queryParameters: [String: CustomStringConvertible]? = nil,
         bodyParameters: Encodable? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.type = type
        self.headers = [.xRequestID: UUID().uuidString]
        self.queryParameters = queryParameters ?? [:]
        self.bodyParameters = bodyParameters
    }
}
