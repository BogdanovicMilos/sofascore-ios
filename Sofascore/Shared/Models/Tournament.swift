//
//  Tournament.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

struct Tournament: Decodable {
    
    // MARK: - Properties
    
    let details: TournamentDetails
    let events: [TournamentEvent]
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case details = "tournament"
        case events
    }
}

struct TournamentDetails: Decodable {
    
    // MARK: - Properties
    
    let name: String
}

struct TournamentEvent: Decodable {
    
    // MARK: - Properties
    
    let id: Int
    let time: Date
    let homeTeam: TournamentEventTeam
    let awayTeam: TournamentEventTeam
    let homeScore: TournamentEventScore
    let awayScore: TournamentEventScore
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case time = "startTimestamp"
        case homeTeam
        case awayTeam
        case homeScore
        case awayScore
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let timestamp = try container.decode(TimeInterval.self, forKey: .time)
        self.time = Date(timeIntervalSince1970: timestamp)
        self.homeTeam = try container.decode(TournamentEventTeam.self, forKey: .homeTeam)
        self.awayTeam = try container.decode(TournamentEventTeam.self, forKey: .awayTeam)
        self.homeScore = try container.decode(TournamentEventScore.self, forKey: .homeScore)
        self.awayScore = try container.decode(TournamentEventScore.self, forKey: .awayScore)
    }
}

struct TournamentEventTeam: Decodable {
    
    // MARK: - Properties
    
    let name: String
}

struct TournamentEventScore: Decodable {
    
    // MARK: - Properties
    
    let current: Int?
    let display: Int?
    let normaltime: Int?
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case current, display, normaltime
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.current = try container.decodeIfPresent(Int.self, forKey: .current)
        self.display = try container.decodeIfPresent(Int.self, forKey: .display)
        self.normaltime = try container.decodeIfPresent(Int.self, forKey: .normaltime)
    }
}
