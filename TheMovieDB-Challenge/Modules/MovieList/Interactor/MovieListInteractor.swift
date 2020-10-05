//
//  MovieInteractor.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

class MovieListInteractor: MovieListPresenterToInteractorProtocol {

    var presenter: MovieListInteractorToPresenterProtocol?
    
    let realm = try! Realm()
 
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection) {
        
        let parameters = ["page": page]
        
        NetworkingService.sharedInstance.genericRequest(endpoint: .getMovies(selection: movieSelection), parameters: parameters, movieSelection: movieSelection) { (result: Result<MovieHeader, errorTypes>) in
            switch result {
            case .success(let movieHeader):
                self.presenter?.returnMovieResults(movieHeader: movieHeader)
            case .failure(let error):
                self.presenter?.problemOnFetchingData(error: error)
            }
            
        }
        
    }

}
