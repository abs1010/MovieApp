//
//  MovieDataProvider.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum errorTypes: Error {
    case ErrorOnGettingData
    case NoDataAvailable
    case CanNotProccessData
}

struct NetworkingService {
    
    static let sharedInstance = NetworkingService()
    
    private init() {}
    
    private enum API {
        static let baseURL = "https://api.themoviedb.org/3"
        static let privateKey = "132dfc8e68a337152fd3e36d63c77677"
        static let publicKey = ""
        static let imageURLBanner = "https://image.tmdb.org/t/p/w1280"
        static let imageURLCover = "https://image.tmdb.org/t/p/original"
    }
    
    private enum language : String {
        case Portuguese = "pt-BR"
        case English = "en-US"
        case Spanish = "es-ES"
    }
    
    enum Endpoints {
        
        case getMovies(selection: Constants.MovieSelection)
        case getSeries
        case getGenres
        case getMovieDetails(id: Int)
        case getMovieCast(id: Int)
        case getMovieTrailer(id: Int)
        
        var url: String {
            switch self {
            case .getMovies(let movieSelection):
                return "\(API.baseURL)/movie/\(movieSelection.rawValue)"
            case .getSeries:
                return "\(API.baseURL)/series/"
            case .getGenres:
                return "\(API.baseURL)/genre/"
            case .getMovieDetails(let id):
                return "\(API.baseURL)/movie/\(id)"
            case .getMovieCast(let id):
                return "\(API.baseURL)/movie/\(id)/credits"
            case .getMovieTrailer(let id):
                return "\(API.baseURL)/movie/\(id)/videos"
            }
            
        }
        
    }
    
    //MARK: - Exposed Methods
    
    func getUrl(str: String, type: Constants.imageType) -> URL {
        
        let urlString = type == .banner ? "\(API.imageURLBanner)\(str)" : "\(API.imageURLCover)\(str)"
        
        return URL(string: urlString)!
        
    }
    
    private func showApiLog(_ url: String, page: Int = 0) {
        
        if page > 0 {
            print(String.init(repeating: "-", count: 56) + "API LOG" + String.init(repeating: "-", count: 57))
            print("Page#\(page) \(url)")
            print(String.init(repeating: "-", count: 120));print("")
            return
        }
        print(String.init(repeating: "-", count: 53) + "API LOG" + String.init(repeating: "-", count: 53))
        print("URL: #\(url)")
        print(String.init(repeating: "-", count: 120));print("")
        
    }
    
    private func genParams(_ parameters: [String: Any]) -> [URLQueryItem] {
        
        var array: [URLQueryItem] = []
        array.append(URLQueryItem(name: "api_key", value: API.privateKey))
        array.append(URLQueryItem(name: "language", value: language.English.rawValue))
        if let page = parameters["page"] as? Int {
            array.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        return array
    }
    
    func genericRequest<T: Codable>(endpoint: Endpoints, parameters: [String: Any] = [:], movieSelection: Constants.MovieSelection? = .NoSelection, completion : @escaping (Result<T, errorTypes>) -> Void) {
        
        var components = URLComponents(string: endpoint.url)!
        
        components.queryItems = genParams(parameters)
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        if let page = parameters["page"] as? Int {
            self.showApiLog(request.url!.absoluteString, page: page)
        }else {
            self.showApiLog(request.url!.absoluteString)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.ErrorOnGettingData))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.NoDataAvailable))
                return
            }
            
            do {
                let decodedObj = try JSONDecoder().decode(T.self, from: jsonData)
                
                ///For Object Mapper
//                if let JSONString = String(data: jsonData, encoding: .utf8) {
//                    guard let decodedObj = MovieTrailer(JSONString: JSONString) else { return }
//                }
                
                if let categoryType = movieSelection {
                    if categoryType != .NoSelection {
                        var movieHeader = decodedObj as! MovieHeader
                        movieHeader.categoryType = categoryType
                        completion(.success(movieHeader as! T))
                        return
                    }
                }
                
                completion(.success(decodedObj))
            }catch {
                completion(.failure(.CanNotProccessData))
            }
            
        }.resume()
        
    }
    
}
