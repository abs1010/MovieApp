//
//  DetailsPresenter.swift
//  TheMovieDB
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class DetailsPresenter: DetailsViewToPresenterProtocol {
    
    var view: DetailsPresenterToViewProtocol?
    var interactor: DetailsPresenterToInteractorProtocol?
    var router: DetailsPresenterToRouterProtocol?
    
    func getMovieInfo(for movieId: Int) {
        
        interactor?.getMovieInfo(for: movieId)
        
    }
    
    func isFavorite(_ movieID: Int, completion: @escaping (Bool) -> Void) {
        
        completion(DataManager.sharedInstance.isFavorite(movieID: movieID))
        
    }
    
    func saveAsFavorite(movie: Movie?) {
        
        DataManager.sharedInstance.saveFavoriteMovie(movie: movie)
        
    }
    
    func removeFromFavorites(_ movieID: Int, completion: @escaping (Bool) -> Void) -> Void {
        
        DataManager.sharedInstance.removeFavoriteMovie(id: movieID)
        
        completion(true)
        
    }
    
}

extension DetailsPresenter: DetailsInteractorToPresenterProtocol {
    
    func didGetMovieInfo(movieDetails: MovieDetails, cast: [CastElement], videoID: String) {
        view?.showRequestResults(movieDetails: movieDetails, cast: cast, videoID: videoID)
    }
    
}
