//
//  API.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import Foundation

struct Constant {
    static let API_KEY = "facd9c0936bedd787095cb6be1ef03c0"
    static let baseURL = "https://api.themoviedb.org"
    static let imagePath = "https://image.tmdb.org/t/p/w500/"
}

enum APIError: Error {
    case failedToGetData
}

final class API {
    
    enum MovieType: String {
        case movie
        case tv
    }
    
    enum MovieStatus: String {
        case upcoming
        case popular
        case topRated = "top_rated"
    }
    
    static let shared: API = .init()
    
    func getTrendingTitles(forType type: MovieType, completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/trending/\(type.rawValue)/day?api_key=\(Constant.API_KEY)")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovies(forStatus status: MovieStatus, completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/movie/\(status.rawValue)?api_key=\(Constant.API_KEY)&language=en-US&page=1")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }

    
}
