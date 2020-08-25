//
//  MovieDataProvider.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

typealias GenericResponse<T> = (_ value: T?, _ success: Bool, _ error : Constants.errorTypes?) -> Void

struct NetworkingService {
    
    static let shared = NetworkingService()
    
    let language: Constants.language = .English //Replace by UserDefaults
    
    enum Endpoints {
        case getMovies
        case getSeries
        case getGenres
        
        var url: String {
            switch self {
            case .getMovies:
                return "\(Constants.API.baseURL)/movie/"
            case .getSeries:
                return "\(Constants.API.baseURL)/series/"
            case .getGenres:
                return "\(Constants.API.baseURL)/genre/"
            }
            
        }
        
    }
    
}
