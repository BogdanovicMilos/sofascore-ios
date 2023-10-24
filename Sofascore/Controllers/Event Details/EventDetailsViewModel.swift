//
//  EventDetailsViewModel.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import UIKit

final class EventDetailsViewModel: ObservableObject {
    
    // MARK: - Properties
    
    var event: EventDetails
   
    // MARK: - Initializers
    
    init(event: EventDetails) {
        self.event = event
    }
    
    // MARK: - Public API
    
}
