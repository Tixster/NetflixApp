//
//  HeroHeaderUIView.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

final class HeroHeaderUIView: UIView {
    
    private var titleMovie: Title!
    
    private let heroImageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let playButton: HeroHeaderButton = .init(title: "Play")
    private let downloadButton: HeroHeaderButton = {
        let btn: HeroHeaderButton = .init(title: "Download")
        btn.addTarget(nil, action: #selector(tapDownload), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = self.bounds
    }
    
    public func set(with model: Title) {
        self.titleMovie = model
        let url: URL = .init(stringLiteral: Constant.imagePath + (model.posterPath ?? ""))
        DispatchQueue.main.async {
            self.heroImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}

private extension HeroHeaderUIView {
    
    @objc
    func tapDownload() {
        DataPersistenceManager.shared.downloadTitleWith(model: titleMovie) { result in
            switch result {
            case .success():
                print("++++++")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setup() {
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstaints()
    }

    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.black.cgColor]
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
    }
    
    func applyConstaints() {
        let playButtonConstaints: [NSLayoutConstraint] = [
            playButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 90),
            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonConstraints: [NSLayoutConstraint] = [
            downloadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -90),
            downloadButton.bottomAnchor.constraint(equalTo: self.playButton.bottomAnchor),
            downloadButton.widthAnchor.constraint(equalTo: playButton.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(playButtonConstaints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
}
