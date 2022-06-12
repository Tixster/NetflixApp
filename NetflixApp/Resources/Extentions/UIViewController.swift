//
//  UIViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import Foundation
import UIKit
import SafeSFSymbols

extension UIViewController {
    
    func configureForTabBar(title: String, symbol: SafeSFSymbol) {
        self.tabBarItem.image = UIImage(symbol)
        self.title = title
        self.view.backgroundColor = .black
    }
    
    func setupNavBar() {
        title = navigationController?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
    }
    
}
