//
//  URL.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = URL(string: value)!
    }
    
}
