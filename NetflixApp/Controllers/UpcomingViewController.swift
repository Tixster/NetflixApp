//
//  UpcomingViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = navigationController?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }

}
