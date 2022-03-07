//
//  HeroHeaderUIView.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

final class HeroHeaderUIView: UIView {
    
    private let heroImageView: UIImageView = {
        let view: UIImageView = .init()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = .init(named: "heroImage")
        return view
    }()
    
    private let playButton: HeroHeaderButton = .init(title: "Play")
    private let downloadButton: HeroHeaderButton = .init(title: "Download")

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
    
}

private extension HeroHeaderUIView {
    
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
                                UIColor.systemBackground.cgColor]
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
