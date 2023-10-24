//
//  EventDetailsViewController.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let eventView = EventDetailsView()
    private let viewModel: EventDetailsViewModel
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Initializers
    
    init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private API
    
    private func setup() {
        eventView.configure(viewModel: viewModel)
        eventView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventView)
        
        NSLayoutConstraint.activate([
            eventView.topAnchor.constraint(equalTo: view.topAnchor),
            eventView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            eventView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
