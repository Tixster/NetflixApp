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
    
    private init() {}
    
    static let shared: API = .init()
    private let session: URLSession = .shared
    
    public func getTrendingTitles(forType type: MovieType, completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/trending/\(type.rawValue)/day?api_key=\(ApiKeys.API_KEY)")
        Task {
            let result = await sendRequest(url: url, type: TrendingTitleResponse.self)
            switch result {
            case .success(let trendingTitleResponse):
                completion(.success(trendingTitleResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMovies(forStatus status: MovieStatus, completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: Constant.baseURL + "/3/movie/\(status.rawValue)?api_key=\(ApiKeys.API_KEY)&language=en-US&page=1")
        Task {
            let result = await sendRequest(url: url, type: TrendingTitleResponse.self)
            switch result {
            case .success(let trendingTitleResponse):
                completion(.success(trendingTitleResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getDiscoverMoview(completion: @escaping (Result<[Title], Error>) -> Void) {
        let url: URL = .init(stringLiteral: "\( Constant.baseURL)/3/discover/movie?api_key=\(ApiKeys.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate")
        Task {
            let result = await sendRequest(url: url, type: TrendingTitleResponse.self)
            switch result {
            case .success(let trendingTitleResponse):
                completion(.success(trendingTitleResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        print(query)
        let url: URL = .init(stringLiteral: "\( Constant.baseURL)/3/search/movie?api_key=\(ApiKeys.API_KEY)&query=\(query)")
        Task {
            let result = await sendRequest(url: url, type: TrendingTitleResponse.self)
            switch result {
            case .success(let trendingTitleResponse):
                completion(.success(trendingTitleResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMovie(with query: String, completion: @escaping (Result<VideoModel, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url: URL = .init(stringLiteral: "\(Constant.YouTubeBaseURL)q=\(query)&key=\(ApiKeys.YouTube_API_KEY)")
        Task {
            let result = await sendRequest(url: url, type: YouTubeSearchModel.self)
            switch result {
            case .success(let youTubeSearchModel):
                completion(.success(youTubeSearchModel.items[0]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private extension API {
    func sendRequest<T: Decodable>(url: URL, type: T.Type) async -> Result<T, Error> {
        return await withCheckedContinuation { continuation in
            let taks = session.dataTask(with: url) { data, _, error in
                if let error = error {
                    return continuation.resume(returning: .failure(error))
                }
                guard let data = data else {
                    return continuation.resume(returning: .failure(APIError.failedToGetData))
                }
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    return continuation.resume(returning: .success(result))
                } catch let error as NSError {
                    return continuation.resume(returning: .failure(error))
                }
            }
            taks.resume()
        }
    }
}
