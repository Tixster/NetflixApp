//
//  SearchViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private lazy var discoverTable: UITableView = {
        let table: UITableView = .init()
        table.delegate = self
        table.dataSource = self
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController: UISearchController = .init(searchResultsController: SearchResultViewController())
        searchController.searchBar.placeholder = "Search for a Moview or a TV show"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.addSubview(discoverTable)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    

}

private extension SearchViewController {
    
    func fetchDiscoverMovie() {
        API.shared.getDiscoverMoview { result in
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultVC = searchController.searchResultsController as? SearchResultViewController
        else { return }
        resultVC.didTapCellCallback = { [weak self] preview in
            DispatchQueue.main.async {
                let previewVC: TitlePreviewViewController = .init()
                previewVC.set(with: preview)
                self?.navigationController?.pushViewController(previewVC, animated: true)
            }
        }
        API.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultVC.set(titles: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseID, for: indexPath) as? TitleTableViewCell
        else { return TitleTableViewCell() }
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.originalTitle ?? "", poseterURL: title.posterPath ?? "")
        cell.set(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.originalTitle ?? title.originalName else { return }
        API.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    let previewVC: TitlePreviewViewController = .init()
                    let previewTitle: TitlePreviewModel = .init(title: titleName,
                                                                youtubeView: movie,
                                                                titleOverview: title.overview ?? "")
                    previewVC.set(with: previewTitle)
                    self.navigationController?.pushViewController(previewVC, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

}
