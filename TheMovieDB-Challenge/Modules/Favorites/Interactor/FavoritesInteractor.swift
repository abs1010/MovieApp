//
//  FavoritesInteractor.swift
//  TheMovieApp
//
//  Created by Alan Silva on 23/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class FavoritesInteractor: FavoritesPresenterToInteractorProtocol {
    
    var presenter: FavoritesInteractorToPresenterProtocol?
    
    func getFavoriteMovies() {
        
        presenter?.didGetFavoriteMovies(movies: DataManager.sharedInstance.loadFavoriteMovies())
        
    }
    
}
