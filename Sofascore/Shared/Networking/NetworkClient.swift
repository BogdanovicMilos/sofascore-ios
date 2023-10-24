//
//  NetworkClient.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation
import Combine
import SystemConfiguration
import UIKit

final class NetworkClient {
    fileprivate enum Constants {
        static let timeoutInterval: TimeInterval = 60
        static let memoryCacheSizeMB = 25 * 1024 * 1024
        static let diskCacheSizeMB = 250 * 1024 * 1024
    }
    
    // MARK: - Properties
    
    private static let cache: URLCache = URLCache(memoryCapacity: Constants.memoryCacheSizeMB,
                                                  diskCapacity: Constants.diskCacheSizeMB,
                                                  diskPath: String(describing: NetworkClient.self))
    
    private static let sessionConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.urlCache = cache
        return configuration
    }()
    
    private var session = URLSession(configuration: sessionConfiguration)
    
    // MARK: - Public API
    
    func dataTaskPublisher<T: NetworkRequest>(with request: T) -> AnyPublisher<T.Response, NetworkError> {
        let urlRequest = request.build()
        
        if !isConnectedToNetwork() {
            return AnyPublisher(Fail<T.Response, NetworkError>(error: .noConnectivity))
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .retry(1)
            .receive(on: DispatchQueue.main)
            .tryMap { output in
                let decodedData: Result<T.Response, NetworkError> = self.decodeData(request: urlRequest, response: output.response, data: output.data, decoder: T.decoder, storeInCache: request.storeInCache)
                switch decodedData {
                case .success(let responseData):
                    return responseData
                case .failure(let error):
                    throw error
                }
            }
            .mapError { (error) -> NetworkError in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.error(code: -1, reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func dataTask<T: NetworkRequest>(with request: T, completion: @escaping (Result<T.Response, NetworkError>) -> Void) -> URLSessionDataTask? {
        func handleCompletion(result: Result<T.Response, NetworkError>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let urlRequest = request.build()
        
        if !isConnectedToNetwork() {
            handleCompletion(result: .failure(.noConnectivity))
            return nil
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error, let response = response as? HTTPURLResponse {
                handleCompletion(result: .failure(.error(code: response.statusCode, reason: error.localizedDescription)))
            } else if let data = data {
                let result: Result<T.Response, NetworkError> = self.decodeData(request: urlRequest, response: response, data: data, decoder: T.decoder, storeInCache: request.storeInCache)
                handleCompletion(result: result)
            } else {
                handleCompletion(result: .failure(NetworkError.unknown))
            }
        }
        task.resume()
    
        return task
    }
    
    @available(iOS 15.0, *)
    func dataTask<T: NetworkRequest>(with request: T) async throws -> T.Response {
        let urlRequest = request.build()
        
        if !isConnectedToNetwork() {
            throw NetworkError.noConnectivity
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        let decodedData: Result<T.Response, NetworkError> = self.decodeData(request: urlRequest, response: response, data: data, decoder: T.decoder, storeInCache: request.storeInCache)
        switch decodedData {
        case .success(let response):
            return response
        case .failure(let failure):
            throw failure
        }
    }
}

extension NetworkClient {
    func decodeData<T: Decodable>(request: URLRequest, response: URLResponse?, data: Data, decoder: JSONDecoder, storeInCache: Bool) -> Result<T, NetworkError> {
        guard let response = response as? HTTPURLResponse else {
            return .failure(.unknown)
        }
        
        func storeInCacheIfNecessary() {
            guard storeInCache else { return }
            let cachedData = CachedURLResponse(response: response, data: data)
            Self.cache.storeCachedResponse(cachedData, for: URLRequest(url: request.url!))
        }
        
        switch response.statusCode {
        case 200 ... 299:
            do {
                var responseObject: T
                if let object = data as? T {
                    responseObject = object
                } else {
                    responseObject = try decoder.decode(T.self, from: data)
                }
                
                storeInCacheIfNecessary()
                
                return .success(responseObject)
            } catch let error {
                print(error)
                return .failure(.error(code: response.statusCode, reason: error.localizedDescription))
            }
        default:
            let error = NetworkError.error(code: response.statusCode, reason: response.description)
            NetworkClient.multicastDelegate.invoke { $0.networkClient(self, didFinishRequest: request, withError: error) }
            return .failure(error)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

        return (isReachable && !needsConnection)
    }
}

protocol DataLoaderObservable {
    func networkClient(_ networkClient: NetworkClient, didFinishRequest request: URLRequest, withError error: NetworkError)
}

extension NetworkClient {
    private static let multicastDelegate = MulticastDelegate<DataLoaderObservable>()
    
    static func addObservable(_ observable: DataLoaderObservable) {
        NetworkClient.multicastDelegate.add(observable)
    }
    
    static func removeObservable(_ observable: DataLoaderObservable) {
        NetworkClient.multicastDelegate.remove(observable)
    }
}
