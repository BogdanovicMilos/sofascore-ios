//
//  EventsService.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

protocol EventsService {
    func fetchEventsIds() async throws -> [Int]
    func fetchEvent(id: Int) async throws -> EventDetails
}

final class DefaultEventsService: EventsService {
    
    // MARK: - Properties
    
    private let networkingClient: NetworkClient
    
    // MARK: - Initializers
    
    init(networkingClient: NetworkClient = NetworkClient()) {
        self.networkingClient = networkingClient
    }
    
    // MARK: - EventsService
    
    func fetchEventsIds() async throws -> [Int] {
        let path = "unique-tournament/17/current-event-ids"
        let request = APIRequest<[Int]>(path: path, type: .get)
        let response = try await networkingClient.dataTask(with: request)
        return response
    }
    
    func fetchEvent(id: Int) async throws -> EventDetails {
        let path = "event/\(id)/details"
        let request = APIRequest<EventDetailsResponse>(path: path, type: .get)
        let response = try await networkingClient.dataTask(with: request)
        return response.events.first!
    }
}

final class MockEventsService: EventsService {
    
    // MARK: - EventsService
    
    func fetchEventsIds() async throws -> [Int] {
        [11352391, 11352370, 11352382, 11352393]
    }
    
    func fetchEvent(id: Int) async throws -> EventDetails {
        fatalError()
    }
}

