//
//  MovieDataProvider.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

typealias GenericResponse<T> = (_ value: T?, _ success: Bool, _ error : errorTypes?) -> Void

enum errorTypes: Error {
    case NoError
    case NoDataAvailable
    case CanNotProccessData
}

struct NetworkingService {
    
    static let sharedInstance = NetworkingService()
    
    private enum API {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageURLBanner = "https://image.tmdb.org/t/p/w1280"
        static let imageURLCover = "https://image.tmdb.org/t/p/original"
        static let faceImage = "https://image.tmdb.org/t/p/w276_and_h350_face//hPwCMEq6jLAidsXAX5BfoYgIfg2.jpg"
        static let publicKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        static let privateKey = "132dfc8e68a337152fd3e36d63c77677"
    }
    
    private enum language : String {
        
        case Portuguese = "pt-BR"
        case English = "en-US"
        case Spanish = "es-ES"
        
    }
    
    private enum MovieEndpoint {
        case account_states
        case alternative_titles
        case changes
        case credits
        case external_ids
        case images
        case keywords
        case release_dates
        case videos
        case translations
        case recommendations
        case similar
        case reviews
        case lists
        case rating//POST DELETE
        
    }
    
    enum Endpoints {
        
        case getMovies(selection: Constants.MovieSelection)
        case getSeries
        case getGenres
        case getMovieID(id: Int)
        case getMovieCast(id: Int)
        
        var url: String {
            
            let appLanguage = language.Portuguese.rawValue //Replace by UserDefaults
            
            switch self {
            case .getMovies(let movieSelection):
                return "\(API.baseURL)/movie/\(movieSelection.rawValue)?api_key=\(API.privateKey)&language=\(appLanguage)"
            case .getSeries:
                return "\(API.baseURL)/series/"
            case .getGenres:
                return "\(API.baseURL)/genre/"
            case .getMovieID(let id):
                return "\(API.baseURL)/movie/\(id)?api_key=\(API.privateKey)&language=\(appLanguage)"
            case .getMovieCast(let id):
                return "\(API.baseURL)/movie/\(id)/credits?api_key=\(API.privateKey)&language=\(appLanguage)"
            }
            
        }
        
    }
    
    //MARK: - Exposed Methods
    
    func getUrl(str: String, type: Constants.imageType) -> URL {
        
        let urlString = type == .banner ? "\(API.imageURLBanner)\(str)" : "\(API.imageURLCover)\(str)"
        
        return URL(string: urlString)!
        
    }
    
}
