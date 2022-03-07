//
//  MainTabBarViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private let homeVC: UINavigationController = .init(rootViewController: HomeViewController())
    private let upcomingVC: UINavigationController = .init(rootViewController: UpcomingViewController())
    private let searchVC: UINavigationController = .init(rootViewController: SearchViewController())
    private let downloadVC: UINavigationController = .init(rootViewController: DownloadViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

}

private extension MainTabBarViewController {
    
    func setupTabBar() {
        homeVC.configureForTabBar(title: "Home", symbol: .house)
        upcomingVC.configureForTabBar(title: "Coming Soon", symbol: .play.circle)
        searchVC.configureForTabBar(title: "Top Search", symbol: .magnifyingglass)
        downloadVC.configureForTabBar(title: "Downloads", symbol: .arrow.downToLine)
        let vcList: [UINavigationController] = [homeVC, upcomingVC, searchVC, downloadVC]
        self.tabBar.tintColor = .label
        self.setViewControllers(vcList, animated: true)
    }

}
