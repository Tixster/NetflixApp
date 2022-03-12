//
//  API.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 07.03.2022.
//

import Foundation

struct Constant {
    static let baseURL = "https://api.themoviedb.org"
    static let imagePath = "https://image.tmdb.org/t/p/w500/"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
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
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/trending/\(type.rawValue)/day?api_key=\(ApiKeys.API_KEY)")
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
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/movie/\(status.rawValue)?api_key=\(ApiKeys.API_KEY)&language=en-US&page=1")
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
    
    func getDiscoverMoview(completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: "\( Constant.baseURL)/3/discover/movie?api_key=\(ApiKeys.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate")
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
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        print(query)
        let url: URL = .init(stringLiteral: "\( Constant.baseURL)/3/search/movie?api_key=\(ApiKeys.API_KEY)&query=\(query)")
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
    
    func getMovie(with query: String, completion: @escaping (Result<VideoModel, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url: URL = .init(stringLiteral: "\(Constant.YouTubeBaseURL)q=\(query)&key=\(ApiKeys.YouTube_API_KEY)")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(YouTubeSearchModel.self, from: data)
                completion(.success(result.items[0]))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
