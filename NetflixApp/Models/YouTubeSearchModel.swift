//
//  YouTubeSearchModel.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 12.03.2022.
//

import Foundation

struct YouTubeSearchModel: Codable {
    let items: [VideoModel]
}

struct VideoModel: Codable {
    let id: IDVideoModel
}

struct IDVideoModel: Codable {
    let kind: String
    let videoId: String
}
