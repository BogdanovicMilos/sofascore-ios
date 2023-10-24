//
//  EventId.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/17/23.
//

import CoreData

@objc(EventId)
class EventId: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var eventId: Int
}
