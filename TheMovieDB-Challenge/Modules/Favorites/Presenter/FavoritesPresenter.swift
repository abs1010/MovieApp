//
//  FavoritesPresenter.swift
//  TheMovieApp
//
//  Created by Alan Silva on 23/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class FavoritesPresenter: FavoritesViewToPresenterProtocol {
    
    weak var view: FavoritesPresenterToViewProtocol?
    var interactor: FavoritesPresenterToInteractorProtocol?
    var router: FavoritesPresenterToRouterProtocol?
    
    private var favoriteMoviesArray: [Movie] = []
    private var notFilteredFavoriteMoviesArray: [Movie] = []
    
    func getFavoriteMovies() {
        
        interactor?.getFavoriteMovies()
        
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return favoriteMoviesArray.count
    }
    
    func loadMovieWithIndexPath(indexPath: IndexPath) -> Movie {
        
        return favoriteMoviesArray[indexPath.row]
        
    }
    
    func searchByValue(searchText: String) {
        
        guard !searchText.isEmpty else {
            resetArray()
            return
        }
        
        favoriteMoviesArray = notFilteredFavoriteMoviesArray.filter({ movie -> Bool in
            (movie.title?.lowercased().contains(searchText.lowercased()))!
        })
        
    }
    
    func resetArray() {
        
        favoriteMoviesArray = notFilteredFavoriteMoviesArray
        
    }
    
    func showMovie(row: Int) {
        
        let movie = favoriteMoviesArray[row]
        
        router?.goToMovieDetailsViewController(movie: movie, for: view as! FavoritesViewController)
        
    }

}

extension FavoritesPresenter: FavoritesInteractorToPresenterProtocol {
    
    func didGetFavoriteMovies(movies: [Movie]) {
        
        favoriteMoviesArray = movies
        notFilteredFavoriteMoviesArray = movies
        view?.showRequestResults(movies)
        
    }
    
    func FailRequestResults() {
        
    }

}
