//
//  HeroHeaderButton.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import UIKit

final class HeroHeaderButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero) 
        self.setTitle(title, for: .normal)
    }

}
