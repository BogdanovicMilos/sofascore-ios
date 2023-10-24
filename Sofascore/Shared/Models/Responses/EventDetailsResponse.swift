//
//  EventDetailsResponse.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/18/23.
//

import Foundation

struct EventDetailsResponse: Decodable {
    
    // MARK: - Properties
    
    let events: [EventDetails]
    
    // MARK: - CodingKeys
    
    enum RootKeys: String, CodingKey {
        case game
    }
    
    enum GameKeys: String, CodingKey {
        case tournaments
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let gameContainer = try container.nestedContainer(keyedBy: GameKeys.self, forKey: .game)
        let tournaments = try gameContainer.decode([Tournament].self, forKey: .tournaments)
        var tournamentEvents = [EventDetails]()
        tournaments.forEach { tournament in
            let events = tournament.events.compactMap { event in
                EventDetails(id: event.id,
                             tournamentName: tournament.details.name,
                             homeTeam: event.homeTeam.name,
                             awayTeam: event.awayTeam.name,
                             homeScore: event.homeScore.current,
                             awayScore: event.awayScore.current,
                             time: event.time,
                             favourite: false)
            }
            
            tournamentEvents.append(contentsOf: events)
        }
        
        self.events = tournamentEvents
    }
}
