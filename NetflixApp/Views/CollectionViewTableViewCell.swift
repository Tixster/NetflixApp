//
//  CollectionViewTableViewCell.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

final class CollectionViewTableViewCell: UITableViewCell {

    static let reuseID = String(describing: CollectionViewTableViewCell.self)
    private var titles: [Title] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reuseID)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func set(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

private extension CollectionViewTableViewCell {
    
    func setupCell() {
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reuseID, for: indexPath) as? TitleCollectionViewCell else { return TitleCollectionViewCell() }
        
        guard let poserPath = titles[indexPath.item].posterPath else { return TitleCollectionViewCell() }
        let url: URL = .init(stringLiteral: Constant.imagePath + poserPath)
        cell.set(url: url)
        return cell
    }
    
}
