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
}

enum APIError: Error {
    case failedToGetData
}

final class API {
    static let shared: API = .init()
    
    func getTrendingMovies(completion: @escaping (Result<TrendingMovieResponse, Error>) -> Void) {
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/trending/movie/day?api_key=\(Constant.API_KEY)")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(result))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
