//
//  EventListViewModel.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import UIKit
import Combine

final class EventListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isLoading = false
    @Published var eventsList = [EventDetails]()
    @Published var eventIds = [Int]()
    
    private var events = [EventDetails]()
    var sortedEventsSet = Set<EventDetails>()
    let eventsStore: EventStore
   
    @Published var eventObjIds = [Int]()
    
    private let repository: EventsRepository

    // MARK: - Initializer
    
    init(eventStore: EventStore = EventStore(),
         repository: EventsRepository = DefaultEventsRepository()) {
        self.eventsStore = eventStore
        self.repository = repository
        
//        getData()
    }
    
    // MARK: - Public API
    
    func getData() {
        events = EventDetails.events
    }
    
    func fetchEventIds() {
        Task {
            isLoading.toggle()
            
            do {
                for try await data in eventsStore.fetchEventsIds() {
                    if !data.isEmpty{
                        eventObjIds = data
                    }
//                    fetchEvents(ids: eventObjIds)
                }
                
//                fetchEvents(ids: eventObjIds)
            } catch {
                print("Handle error appropriately: \(error)")
            }
        }
    }
    
    func fetchEvents(ids: [Int]) {
        Task {
            do {
                for try await events in eventsStore.fetchEvents(id: ids) {
                    if !events.isEmpty {
                        repository.deleteEvents()
                        repository.saveEvents(events: events)
                        eventsList.append(contentsOf: events)
                        isLoading.toggle()
                    }
                    
                }
                
//                isLoading.toggle()
            } catch {
                print("Handle error appropriately: \(error)")
            }
        }
    }
        
        
//        Task {
//            do {
//                isLoading = true
//                for eventId in ids {
//                    for try await event in self.eventsStore.fetchEvent(id: eventId) {
////                        sortedEventsSet.insert(event)
//                        eventsList.append(event)
//                    }
//                }
//                
//                isLoading = false
////                eventsList.append(contentsOf: Array(sortedEventsSet).sorted(by: { $0.time < $1.time }))
//            } catch {
//                print("Handle error appropriately: \(error)")
//            }
//        }
//    }
}
