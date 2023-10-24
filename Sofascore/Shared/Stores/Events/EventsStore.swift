//
//  EventStore.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation
import UIKit

protocol EventsStore {
    func fetchEventsIds() async throws -> [String]
    func fetchEvent(id: String) async throws -> Event
    func deleteIds() async
}

final class EventStore: ObservableObject {
    
    // MARK: - Properties
    
    private let service: EventsService
    private let repository: EventsRepository
    private let client: NetworkClient
    
    // MARK: - Initializers
    
    init(service: EventsService = DefaultEventsService(),
         repository: EventsRepository = DefaultEventsRepository(),
         client: NetworkClient = NetworkClient()) {
        
        self.service = service
        self.repository = repository
        self.client = client
    }
    
    // MARK: - EventsStore
    
    func fetchEventsIds() -> AsyncThrowingStream<[Int], Error> {
        AsyncThrowingStream(bufferingPolicy: .bufferingNewest(1)) { continuation in            
            if let local = repository.fetchAllEventIds() {
                continuation.yield(local)
            }
            
            Task {
                do {
                    if client.isConnectedToNetwork() {
                        let eventIds = try await service.fetchEventsIds()
                        repository.deleteIds()
                        repository.saveEventsIds(ids: eventIds)
                        continuation.yield(eventIds)
                        continuation.finish()
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    func fetchEvents(id: [Int]) -> AsyncThrowingStream<[EventDetails], Error> {
        AsyncThrowingStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
            if let local = repository.fetchEvents(id: id) {
                continuation.yield(local)
            }
            
            Task {
                do {
                    if client.isConnectedToNetwork() {
                        var list = [EventDetails]()
                        var isSaved: Bool = false
                        
                        for eventId in id {
                            let event = try await service.fetchEvent(id: eventId)
//                            repository.deleteEvent(id: eventId)
//                            isSaved = repository.saveEvent(event: event)
                            list.append(event)
                            
//                            if isSaved {
//                                list.append(event)
//                            }
                        }
                        
                        continuation.yield(list)
                        continuation.finish()
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
//    func fetchEvent(id: Int) -> AsyncThrowingStream<EventDetails, Error> {
//        AsyncThrowingStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
//            if let local = repository.fetchEventId(id: id) {
//                continuation.yield(local)
//            }
//            
//            Task {
//                do {
//                    if client.isConnectedToNetwork() {
//                        let event = try await service.fetchEvent(id: id)
//                        repository.deleteEvent(id: event.id)
//                        let isSaved = repository.saveEvent(event: event)
//                        continuation.yield(event)
//                        continuation.finish()
//                        
//                        if isSaved {
//                            continuation.yield(event)
//                            continuation.finish()
//                        } else {
//                            continuation.finish()
//                        }
//                    }
//                } catch {
//                    continuation.finish(throwing: error)
//                }
//            }
//        }
//    }
}
