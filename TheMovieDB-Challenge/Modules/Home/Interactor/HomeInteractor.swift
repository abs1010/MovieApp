//
//  MovieController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 15/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

class HomeInteractor: HomePresenterToInteractorProtocol {
    
    var presenter: HomeInteractorToPresenterProtocol?
    
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection) {
        
        NetworkingService.sharedInstance.getMovies(page: page, category: category, movieSelection: movieSelection) { result in
            
            switch result {
            case .success(let movieHeader):
                self.presenter?.returnMovieResults(movieHeader: movieHeader)
            case .failure(let error):
                self.presenter?.problemOnFetchingData(error: error)
            }
            
        }
        
    }
    
}
