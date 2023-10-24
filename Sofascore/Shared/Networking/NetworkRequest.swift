//
//  NetworkRequest.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

protocol NetworkRequest {
    /// Base URL.
    var baseURL: URL? { get }
    
    /// End point can be a relative path to the base URL or an absolute URL.
    var path: String { get }
    
    /// HTTP request type.
    var type: RequestType { get }
    
    /// HTTP headers.
    var headers: [HTTPHeaderType: String] { get set }
    
    /// HTTP body parameters.
    var bodyParameters: Encodable? { get set }
    
    /// HTTP query parameters.
    var queryParameters: [String: CustomStringConvertible]? { get set }
    
    /// Flag indicating whether to store response in URLCache.
    var storeInCache: Bool { get set }
    
    /// Type the data is decoded to.
    associatedtype Response: Decodable
    
    static var decoder: JSONDecoder { get }
    static var encoder: JSONEncoder { get }
    
    func adding(header type: HTTPHeaderType, value: String?) -> Self
    
    func adding(_ parameters: [String: CustomStringConvertible]) -> Self
}

extension NetworkRequest {
    
    var storeInCache: Bool {
        get { return true }
        set { storeInCache = newValue }
    }
    
    static var decoder: JSONDecoder {
        JSONDecoder()
    }

    static var encoder: JSONEncoder {
        JSONEncoder()
    }
    
    func adding(header type: HTTPHeaderType, value: String?) -> Self {
        var copy = self
        guard let value = value
        else {
            copy.headers.removeValue(forKey: type)
            return copy
        }
        copy.headers[type] = value
        return copy
    }
    
    func adding(_ parameters: [String: CustomStringConvertible]) -> Self {
        var copy = self
        copy.add(parameters: parameters)
        return copy
    }
    
    private mutating func add(parameters: [String: CustomStringConvertible]) {
        self.queryParameters?.merge(parameters, uniquingKeysWith: { lhs, rhs in
            return rhs
        })
    }
    
    func build(timeout: Double = 10) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            fatalError("Cannot construct a valid URL from \(path) and base URL \(baseURL?.absoluteString ?? "")")
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents?.queryItems = httpQueryItems(items: queryParameters)
        }

        guard let requestURL = urlComponents?.url else {
            fatalError("Cannot generate a URL for this network request")
        }
        
        var request = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        var allHeaders = headers
        
        switch type {
        case .get:
            request.httpMethod = "GET"
        case .post:
            request.httpMethod = "POST"
            request.httpBody = httpRequestBody(data: AnyEncodable(bodyParameters))
            allHeaders[.contentType] = "application/json"
        case .put:
            request.httpMethod = "PUT"
            request.httpBody = httpRequestBody(data: AnyEncodable(bodyParameters))
            allHeaders[.contentType] = "application/json"
        case .patch:
            request.httpMethod = "PATCH"
            request.httpBody = httpRequestBody(data: AnyEncodable(bodyParameters))
            allHeaders[.contentType] = "application/json"
        case .delete:
            request.httpMethod = "DELETE"
            allHeaders[.contentType] = "application/json"
        case .multipart(let filename, let data, let mimeType, let formData):
            let boundary = String(format: "Boundary+%08X%08X", arc4random(), arc4random())
            let multipartData = Data(multipartFilename: filename, data: data, fileContentType: mimeType, formData: formData ?? [:], boundary: boundary)
            request.httpMethod = "POST"
            request.httpBody = multipartData
            allHeaders[.contentType] = "multipart/form-data; boundary=\(boundary)"
        }
        
        request.allHTTPHeaderFields = allHeaders

        return request
    }
        
    func httpRequestBody<E>(data: E?) -> Data? where E: Encodable {
        do {
            let data = try Self.encoder.encode(data)
            return data
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func httpQueryItems(items: [String: CustomStringConvertible]) -> [URLQueryItem] {
        let queryItems = items.compactMap { key, value in
            URLQueryItem(name: key, value: value.description)
        }
        return queryItems
    }
}

// MARK: - Helper

private struct AnyEncodable: Encodable {

    private let encodable: Encodable?

    public init(_ encodable: Encodable?) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable?.encode(to: encoder)
    }
}

// MARK: - Header Type

typealias HTTPHeaderType = String

extension HTTPHeaderType {
    static let accept = "Accept"
    static let acceptEncoding = "Accept-Encoding"
    static let acceptLanguage = "Accept-Language"
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let contentEncoding = "Content-Encoding"
    static let contentLength = "Content-Length"
    static let userAgent = "User-Agent"
    static let xClientInfo = "x-client-info"
    static let xRequestID = "x-request-id"
}

// MARK: - Request Type

enum RequestType {
    case get
    case post
    case put
    case patch
    case delete
    case multipart(filename: String, data: Data, mimeType: String, formData: [String: String]?)
}

// MARK: - Multipart Data

extension Data {
    init?(multipartFilename filename: String, data fileData: Data, fileContentType: String, formData: [String: String] = [:], boundary: String) {
        self.init()

        var formFields = formData
        formFields["content-type"] = fileContentType
        formFields.forEach { key, value in
            append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            append("\(value)".data(using: .utf8)!)
        }

        append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        append("Content-Type: \(fileContentType)\r\n\r\n".data(using: .utf8)!)
        append(fileData)

        append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    }
}
