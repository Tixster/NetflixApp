//
//  TitleCollectionViewCell.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit
import SDWebImage

final class TitleCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = String(describing: TitleCollectionViewCell.self)
    
    private let poster: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(poster)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        poster.frame = contentView.bounds
    }
    
    public func set(url: URL?) {
        poster.sd_setImage(with: url, completed: nil)
    }
    
}
