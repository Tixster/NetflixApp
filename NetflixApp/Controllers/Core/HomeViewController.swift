//
//  HomeViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit
import SafeSFSymbols

enum Section: Int {
    case TrendingMovies = 0
    case TrandingTV = 1
    case Popular = 2
    case UpcomingMovies = 3
    case TopRated = 4
}

final class HomeViewController: UIViewController {

    private let sectionTitles: [String] = ["Trending Movies",
                                           "Tranding TV",
                                           "Popular",
                                           "Upcoming Movies",
                                           "Top Rated"]
    
    private var currentScrollOffest: CGFloat = .zero
    private lazy var header = HeroHeaderUIView(frame: .init(x: .zero, y: .zero,
                                                            width: view.bounds.width,
                                                            height: view.bounds.height * 0.45))
    
    private lazy var homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.reuseID)
        table.tableHeaderView = header
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        configureNavBar()
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
        leftItem.imageInsets = .init(top: 5, left: 0, bottom: -5, right: 0)
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItems = [
            .init(image: UIImage(.person), style: .done, target: self, action: nil),
            .init(image: UIImage(.play.rectangle), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
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
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            API.shared.getTrendingTitles(forType: .movie) { [weak self] result in
                switch result {
                case .success(let trandingMovie):
                    self?.header.set(with: trandingMovie.randomElement() ?? trandingMovie[0])
                    cell.set(with: trandingMovie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TrandingTV.rawValue:
            API.shared.getTrendingTitles(forType: .tv) { result in
                switch result {
                case .success(let trandingTV):
                    cell.set(with: trandingTV)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.Popular.rawValue:
            API.shared.getMovies(forStatus: .popular) { result in
                switch result {
                case .success(let popularMovie):
                    cell.set(with: popularMovie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.UpcomingMovies.rawValue:
            API.shared.getMovies(forStatus: .upcoming) { result in
                switch result {
                case .success(let upcomingMovie):
                    cell.set(with: upcomingMovie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Section.TopRated.rawValue:
            API.shared.getMovies(forStatus: .topRated) { result in
                switch result {
                case .success(let topRatedMovie):
                    cell.set(with: topRatedMovie)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return CollectionViewTableViewCell()
        }
        cell.didTapCallback = { [weak self] videoModel in
            DispatchQueue.main.async {
                let previewVC = TitlePreviewViewController()
                previewVC.set(with: videoModel)
                self?.navigationController?.pushViewController(previewVC, animated: true)
            }
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
