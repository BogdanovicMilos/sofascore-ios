//
//  EventTableViewCell.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/16/23.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var teamStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeContainerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var timeHorizontalView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let homeTeam: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let awayTeam: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(family: .helvetica, style: .bold, ofSize: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let date: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(ofSize: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let time: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.custom(ofSize: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verticalSeparator: UIView = {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .black
        return separator
    }()
    
    private static var dateFormatter = DateFormatter()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private API
    
    private func setupView() {
        self.backgroundColor = .systemGray5
        
        timeContainerView.addArrangedSubview(date)
        timeContainerView.addArrangedSubview(time)
        
        timeHorizontalView.addArrangedSubview(timeContainerView)
        timeHorizontalView.addArrangedSubview(verticalSeparator)
        
        teamStackView.addArrangedSubview(homeTeam)
        teamStackView.addArrangedSubview(awayTeam)
        
        containerView.addArrangedSubview(timeHorizontalView)
        containerView.addArrangedSubview(teamStackView)
        
        addSubview(cellView)
        addSubview(containerView)
        
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8),
            
            timeHorizontalView.widthAnchor.constraint(equalToConstant: 90),
                        
            verticalSeparator.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6),
        ])
    }
    
    // MARK: - Public API
    
    func configureCell(event: EventDetails) {
        homeTeam.text = event.homeTeam
        awayTeam.text = event.awayTeam
        
        Self.dateFormatter.dateFormat = "MMM dd, yyyy"
        date.text = Self.dateFormatter.string(from: event.time)
        
        Self.dateFormatter.dateFormat = "HH:mm"
        time.text = Self.dateFormatter.string(from: event.time)
    }
}
