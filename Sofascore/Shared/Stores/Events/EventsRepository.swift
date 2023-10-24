//
//  EventsRepository.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation
import UIKit
import CoreData

protocol EventsRepository {
    func fetchAllEventIds() -> [Int]?
    func fetchEventId(id: Int) -> EventDetails?
    func fetchEvents(id: [Int]) -> [EventDetails]?
    func fetchFavouriteEvents() -> [Event]
    func saveFavouriteEvent(event: Event)
    func saveEventsIds(ids: [Int])
    func saveEvent(event: EventDetails) -> Bool
    func saveEvents(events: [EventDetails]) -> Bool
    func deleteIds()
    func deleteEvents()
    func deleteEvent(id: Int)
}

final class DefaultEventsRepository: EventsRepository {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchAllEventIds() -> [Int]? {
        var eventIds: [Int] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest = NSFetchRequest<EventId>(entityName: "EventId")
        fetchRequest.returnsObjectsAsFaults = false
                
        do {
            
            let results = try context.fetch(fetchRequest)
            
            for data in results {
                eventIds.append(data.eventId)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        return eventIds
    }
    
    func fetchEventId(id: Int) -> EventDetails? {
        var event: EventDetails?
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.predicate = predicate
            
            let result = try context.fetch(fetchRequest)
            if result.count > 0 && result[0].id == id {
                event = EventDetails(id: result[0].id,
                                     tournamentName: result[0].tournamentName,
                                     homeTeam: result[0].homeTeam,
                                     awayTeam: result[0].awayTeam,
                                     homeScore: result[0].homeScore,
                                     awayScore: result[0].awayScore,
                                     time: result[0].time,
                                     favourite: result[0].favourite)
                
                return event
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        return event
    }
    
    func fetchEvents(id: [Int]) -> [EventDetails]? {
        var events = [EventDetails]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results {
                let event = EventDetails(id: result.id,
                                         tournamentName: result.tournamentName,
                                         homeTeam: result.homeTeam,
                                         awayTeam: result.awayTeam,
                                         homeScore: result.homeScore,
                                         awayScore: result.awayScore,
                                         time: result.time,
                                         favourite: result.favourite)
                events.append(event)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
        
        return events
    }
    
    func fetchFavouriteEvents() -> [Event] {
        fatalError()
    }
    
    func saveFavouriteEvent(event: Event) {
        fatalError()
    }
    
    func saveEventsIds(ids: [Int]) {
//        let request: NSFetchRequest = NSFetchRequest<EventId>(entityName: "EventId")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        for eventId in ids {
//            request.predicate = NSPredicate(format: "eventId == %d", eventId)
            let entity = NSEntityDescription.entity(forEntityName: "EventId", in: context)
            
//            let eventIds = EventId(entity: entity!, insertInto: context)
            
            do {
//                eventIds.eventId = eventId
                let newObject = NSManagedObject(entity: entity!, insertInto: context)
                newObject.setValue(eventId, forKey: "eventId")
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func saveEvent(event: EventDetails) -> Bool {
        var isSaved: Bool = false
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: context)
//        let request: NSFetchRequest = NSFetchRequest<Event>(entityName: "Event")
//        request.predicate = NSPredicate(format: "id == %d", event.id)
        
        do {
            let newObject = NSManagedObject(entity: entity!, insertInto: context)
            newObject.setValue(event.id, forKey: "id")
            newObject.setValue(event.tournamentName, forKey: "tournamentName")
            newObject.setValue(event.homeTeam, forKey: "homeTeam")
            newObject.setValue(event.awayTeam, forKey: "awayTeam")
            newObject.setValue(event.homeScore ?? 0, forKey: "homeScore")
            newObject.setValue(event.awayScore ?? 0, forKey: "awayScore")
            newObject.setValue(event.time, forKey: "time")
            newObject.setValue(event.favourite, forKey: "favourite")
            try context.save()
            isSaved.toggle()
            return isSaved
            
            
//            let object = try context.count(for: request)
//            if object == 0 {
//                let eventObject = Event(entity: entity!, insertInto: context)
//                eventObject.id = event.id as Int
//                eventObject.tournamentName = event.tournamentName
//                eventObject.homeTeam = event.homeTeam
//                eventObject.awayTeam = event.awayTeam
//                eventObject.homeScore = event.homeScore ?? 0
//                eventObject.awayScore = event.awayScore ?? 0
//                eventObject.time = event.time
//                eventObject.favourite = event.favourite
//                try context.save()
//                isSaved.toggle()
//                return isSaved
//            }
        } catch {
            print("Error saving context: \(error)")
        }
        return isSaved
    }
    
    func saveEvents(events: [EventDetails]) -> Bool {
        var isSaved: Bool = false
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: context)
//        let request: NSFetchRequest = NSFetchRequest<Event>(entityName: "Event")
//        request.predicate = NSPredicate(format: "id == %d", event.id)
        
        do {
            for event in events {
                let newObject = NSManagedObject(entity: entity!, insertInto: context)
                newObject.setValue(event.id, forKey: "id")
                newObject.setValue(event.tournamentName, forKey: "tournamentName")
                newObject.setValue(event.homeTeam, forKey: "homeTeam")
                newObject.setValue(event.awayTeam, forKey: "awayTeam")
                newObject.setValue(event.homeScore ?? 0, forKey: "homeScore")
                newObject.setValue(event.awayScore ?? 0, forKey: "awayScore")
                newObject.setValue(event.time, forKey: "time")
                newObject.setValue(event.favourite, forKey: "favourite")
                try context.save()
                
            }
            
            isSaved.toggle()
            return isSaved
            
//            let object = try context.count(for: request)
//            if object == 0 {
//                let eventObject = Event(entity: entity!, insertInto: context)
//                eventObject.id = event.id as Int
//                eventObject.tournamentName = event.tournamentName
//                eventObject.homeTeam = event.homeTeam
//                eventObject.awayTeam = event.awayTeam
//                eventObject.homeScore = event.homeScore ?? 0
//                eventObject.awayScore = event.awayScore ?? 0
//                eventObject.time = event.time
//                eventObject.favourite = event.favourite
//                try context.save()
//                isSaved.toggle()
//                return isSaved
//            }
        } catch {
            print("Error saving context: \(error)")
        }
        return isSaved
    }
    
    func deleteIds() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventId")
        
        do {
            let ids = try context.fetch(fetchRequest) as! [NSManagedObject]
            for id in ids {
                context.delete(id)
            }
            
            try context.save()
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
    func deleteEvents() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
//        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
//            try context.execute(batchDeleteRequest)
//            try context.save()
            
            let events = try context.fetch(fetchRequest) as! [NSManagedObject]
            for event in events {
                context.delete(event)
                try context.save()
            }
            
            
        } catch {
            print("Error deleting object: \(error)")
        }
    }
    
    func deleteEvent(id: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let event = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let event = event.first {
                context.delete(event)
                try context.save()
            }
        } catch {
            print("Error deleting object: \(error)")
        }
    }
}

final class MockEventsRepository: EventsRepository {

    func fetchAllEventIds() -> [Int]? {
        [11352391, 11352370, 11352382, 11352393]
    }
    
    func fetchEventId(id: Int) -> EventDetails? {
        fatalError()
    }
    
    func fetchFavouriteEvents() -> [Event] {
        fatalError()
    }
    
    func fetchEvents(id: [Int]) -> [EventDetails]? {
        fatalError()
    }
    
    func saveFavouriteEvent(event: Event) { }
    
    func saveEventsIds(ids: [Int]) { }
    
    func saveEvent(event: EventDetails) -> Bool {
        fatalError()
    }
    
    func deleteIds() { }
    
    func deleteEvents() { }
    
    func deleteEvent(id: Int) { }
    
    func saveEvents(events: [EventDetails]) -> Bool {
        fatalError()
    }
    
}
