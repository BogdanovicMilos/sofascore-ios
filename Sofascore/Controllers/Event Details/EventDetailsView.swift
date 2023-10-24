//
//  EventDetailsView.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/16/23.
//

import Foundation
import UIKit

class EventDetailsView: UIView {
    
    // MARK: - Properties
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerSeparator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .gray
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    private var infoContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var teamContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var scoreContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tournamentContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tournamentName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let homeTeam: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let awayTeam: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let homeScore: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let awayScore: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(ofSize: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(ofSize: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Kick Off:"
        label.textColor = UIColor.black
        label.font = UIFont.custom(ofSize: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookmarkButton: UIView = {
        let buttonView = UIView()
        buttonView.isUserInteractionEnabled = true
        return buttonView
    }()
    
    private let bookmarkImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star"))
        image.tintColor = .systemBlue
        return image
    }()
    
    var buttonAction: (() -> Void)?
    
    private static var dateFormatter = DateFormatter()
    private var viewModel: EventDetailsViewModel?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private API
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        bookmarkButton.addSubview(bookmarkImage)
        bookmarkButton.addGestureRecognizer(tapGesture)
        
        addSubview(overlayView)
        tournamentContainerView.addArrangedSubview(tournamentName)
        tournamentContainerView.addArrangedSubview(bookmarkButton)
        addSubview(tournamentContainerView)
        addSubview(headerSeparator)
                
        teamContainerView.addArrangedSubview(homeTeam)
        teamContainerView.addArrangedSubview(awayTeam)
        containerView.addArrangedSubview(teamContainerView)
        if viewModel?.event.homeScore == nil {
            addSubview(scoreContainerView)
            containerView.addArrangedSubview(scoreContainerView)
        } else {
            scoreContainerView.addArrangedSubview(homeScore)
            scoreContainerView.addArrangedSubview(awayScore)
            
            addSubview(scoreContainerView)
            containerView.addArrangedSubview(scoreContainerView)
        }
        
        timeContainerView.addArrangedSubview(date)
        timeContainerView.addArrangedSubview(time)
        addSubview(timeContainerView)
        
        infoContainerView.addArrangedSubview(infoLabel)
        infoContainerView.addArrangedSubview(timeContainerView)
        
        addSubview(containerView)
        addSubview(infoContainerView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            tournamentContainerView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            tournamentContainerView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            tournamentContainerView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
            
            containerView.leadingAnchor.constraint(equalTo: tournamentName.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: tournamentName.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: tournamentName.topAnchor, constant: 70),
            
            headerSeparator.topAnchor.constraint(equalTo: tournamentContainerView.topAnchor, constant: 34),
            headerSeparator.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            headerSeparator.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            headerSeparator.heightAnchor.constraint(equalToConstant: 2),
            
            infoContainerView.leadingAnchor.constraint(equalTo: tournamentContainerView.leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: tournamentContainerView.trailingAnchor),
            infoContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
            
            bookmarkImage.trailingAnchor.constraint(equalTo: bookmarkButton.trailingAnchor),
        ])

    }
    
    // MARK: - Public API
    
    func configure(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        
        tournamentName.text = viewModel.event.tournamentName
        homeTeam.text = viewModel.event.homeTeam
        awayTeam.text = viewModel.event.awayTeam
        homeScore.text = viewModel.event.homeScore?.description
        awayScore.text = viewModel.event.awayScore?.description
        
        
        Self.dateFormatter.dateFormat = "MMM dd, yyyy"
        date.text = Self.dateFormatter.string(from: viewModel.event.time)
        
        Self.dateFormatter.dateFormat = "HH:mm"
        time.text = Self.dateFormatter.string(from: viewModel.event.time)
        
        setup()
    }
    
    // MARK: - Actions
    
    @objc func buttonTapped() {
        bookmarkImage.image = UIImage(systemName: "star.fill")
        
    }
}
