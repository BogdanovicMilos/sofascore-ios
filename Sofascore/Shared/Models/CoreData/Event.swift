//
//  Event.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import UIKit
import CoreData

@objc(Event)
class Event: NSManagedObject {
    
    // MARK: - Properties
    
    @NSManaged var id: Int
    @NSManaged var tournamentName: String
    @NSManaged var homeTeam: String
    @NSManaged var awayTeam: String
    @NSManaged var homeScore: Int
    @NSManaged var awayScore: Int
    @NSManaged var time: Date
    @NSManaged var favourite: Bool
}
