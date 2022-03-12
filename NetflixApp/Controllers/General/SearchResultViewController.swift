//
//  SearchResultViewController.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 12.03.2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private var titles: [Title] = []
    var didTapCellCallback: ((TitlePreviewModel) -> Void)?
    
    private lazy var searchColletction: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseID)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(searchColletction)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchColletction.frame = view.bounds
    }
    
    func set(titles: [Title]) {
        self.titles = titles
        searchColletction.reloadData()
    }
    
}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseID, for: indexPath) as? TitleCollectionViewCell else { return TitleCollectionViewCell() }
        let title = titles[indexPath.row]
        let url: URL = .init(stringLiteral: Constant.imagePath + (title.posterPath ?? ""))
        cell.set(url: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.originalTitle ?? ""
        API.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let movie):
                let previewTitle: TitlePreviewModel = .init(title: titleName,
                                                            youtubeView: movie,
                                                            titleOverview: title.overview ?? "")
                self?.didTapCellCallback?(previewTitle)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
