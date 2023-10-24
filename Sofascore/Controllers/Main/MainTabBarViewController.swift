//
//  MainTabBarViewController.swift
//  Sofascore
//
//  Created by Milos Bogdanovic on 10/15/23.
//

import Foundation

import UIKit

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private lazy var eventListViewController: UIViewController = {
        let controller = EventListViewController(viewModel: EventListViewModel())
        controller.tabBarItem = UITabBarItem(title: "Events",
                                             image: UIImage(systemName: "sportscourt.fill"),
                                             tag: 0)
        return controller
    }()
    
    private lazy var favouriteViewController: UIViewController = {
        let controller = FavouritesViewController()
        controller.tabBarItem = UITabBarItem(title: "Favourites",
                                             image: UIImage(systemName: "star.fill"),
                                             tag: 1)
        return controller
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
                
        viewControllers = [eventListViewController, favouriteViewController]
        selectedViewController = eventListViewController
    }
    
    // MARK: - Private API
    
    private func configureTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.barTintColor = .black
    }
}
