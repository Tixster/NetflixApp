//
//  UpcomingViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private lazy var upcomingTable: UITableView = {
        let table: UITableView = .init()
        table.delegate = self
        table.dataSource = self
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

}

private extension UpcomingViewController {
    
    func setup() {
        setupNavBar()
        view.addSubview(upcomingTable)
    }
    
    func fetchUpcoming() {
        API.shared.getMovies(forStatus: .upcoming) { result in
            switch result {
            case.success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseID, for: indexPath) as? TitleTableViewCell
        else { return TitleTableViewCell() }
        let title = titles[indexPath.row]
        cell.set(with: .init(titleName: (title.originalTitle ?? title.originalName) ?? "Unknow", poseterURL: title.posterPath ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
