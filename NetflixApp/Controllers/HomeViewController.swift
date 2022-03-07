//
//  HomeViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit
import SPSafeSymbols

final class HomeViewController: UIViewController {
    
    private let sectionTitles: [String] = ["Trending Movies",
                                           "Tranding TV",
                                           "Popular",
                                           "Upcoming Movies",
                                           "Top Rated"]
    
    private var currentScrollOffest: CGFloat = .zero
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.reuseID)
        table.tableHeaderView = HeroHeaderUIView(frame: .init(x: .zero, y: .zero,
                                                              width: view.bounds.width,
                                                              height: view.bounds.height * 0.4))
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        configureNavBar()
        getTrendingMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

private extension HomeViewController {
    
    func configureNavBar() {
        var image: UIImage? = .init(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        let leftItem: UIBarButtonItem = .init(image: image, style: .done,
                                              target: self, action: nil)
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItems = [
            .init(image: UIImage(.person), style: .done, target: self, action: nil),
            .init(image: UIImage(.play.rectangle), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    func getTrendingMovies() {
        API.shared.getTrendingMovies { result in
            switch result {
            case .success(let trandingMovie):
                print(trandingMovie)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = .init(x: header.bounds.origin.x + 20,
                                        y: header.bounds.origin.y,
                                        width: 100,
                                        height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.reuseID,
                                                       for: indexPath) as? CollectionViewTableViewCell
        else {
            return CollectionViewTableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        if currentScrollOffest > offset {
            UIView.animate(withDuration: 0.7) { [weak self] in
                guard let self = self else { return }
                self.navigationController?.navigationBar.transform = .init(translationX:.zero,
                                                                      y: .zero)
            }
            currentScrollOffest = offset
        } else {
            currentScrollOffest = offset
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else { return }
                self.navigationController?.navigationBar.transform = .init(translationX:.zero,
                                                                           y: min(.zero, -self.currentScrollOffest))
                
            }
        }
        
    }
    
}
