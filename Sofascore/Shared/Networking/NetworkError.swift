//
//  NetworkError.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case unknown
    case noConnectivity
    case error(code: Int, reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .noConnectivity:
            return "No internet connectivity"
        case let .error(_, reason):
            return reason
        }
    }
}
