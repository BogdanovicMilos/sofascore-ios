//
//  EventDetails.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/18/23.
//

import Foundation

class EventDetails: Codable, Hashable {
    
    // MARK: - Properties
    
    let id: Int
    let tournamentName: String
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int?
    let awayScore: Int?
    let time: Date
    let favourite: Bool
    
    // MARK: - Initializers
    
    init(id: Int, tournamentName: String, homeTeam: String, awayTeam: String, homeScore: Int?, awayScore: Int?, time: Date, favourite: Bool) {
        self.id = id
        self.tournamentName = tournamentName
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.time = time
        self.favourite = favourite
    }
    
    // MARK: - Equatable
    
    static func == (lhs: EventDetails, rhs: EventDetails) -> Bool { lhs.id == rhs.id }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension EventDetails {
    static var mock: EventDetails {
        EventDetails(id: 1,
                     tournamentName: "Premier League",
                     homeTeam: "Brentford",
                     awayTeam: "Burnley",
                     homeScore: 1,
                     awayScore: 1,
                     time: Date(),
                     favourite: false
        )
    }
    
    static var events: [EventDetails] {
        [
            EventDetails(id: 1,
                         tournamentName: "Premier League",
                         homeTeam: "Brentford",
                         awayTeam: "Burnley",
                         homeScore: nil,
                         awayScore: nil,
                         time: Date(),
                         favourite: false),
            EventDetails(id: 2,
                         tournamentName: "Premier League",
                         homeTeam: "Aston Villa",
                         awayTeam: "Arsenal",
                         homeScore: 1,
                         awayScore: 1,
                         time: Date(),
                         favourite: false),
            EventDetails(id: 3,
                         tournamentName: "Premier League",
                         homeTeam: "Brentford",
                         awayTeam: "Burnley",
                         homeScore: nil,
                         awayScore: nil,
                         time: Date(),
                         favourite: false)
        ]
    }
}
