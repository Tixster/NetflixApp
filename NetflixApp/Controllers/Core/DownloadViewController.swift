//
//  DownloadViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var titles: [TitleItem] = []
    
    private lazy var downloadTitleTable: UITableView = {
        let table: UITableView = .init()
        table.delegate = self
        table.dataSource = self
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.addSubview(downloadTitleTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLocalStorgateForDownload()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTitleTable.frame = view.bounds
    }
    
}

private extension DownloadViewController {
    
    func fetchLocalStorgateForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titleItems):
                self?.titles = titleItems
                DispatchQueue.main.async {
                    self?.downloadTitleTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseID, for: indexPath) as? TitleTableViewCell
        else { return TitleTableViewCell() }
        let title = titles[indexPath.row]
        cell.set(with: .init(titleName: (title.originalTitle ?? title.originalName) ?? "Unknow",
                             poseterURL: title.posterPath ?? ""))
        
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

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    print("+++++")
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        default:
            return
        }
    }
    
}
