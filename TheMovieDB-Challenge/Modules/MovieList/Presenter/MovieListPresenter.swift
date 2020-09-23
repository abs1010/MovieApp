//
//  MoviePresenter.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class MovieListPresenter: MovieListViewToPresenterProtocol {
    
    weak var view: MovieListPresenterToViewProtocol?
    var interactor: MovieListPresenterToInteractorProtocol?
    var router: MovieListPresenterToRouterProtocol?
    
    private var page = 1
    private var totalPages = 1
    
    private var moviesArray : [Movie] = [] // Create another object that holds the page # as well
    private var notFilteredArray : [Movie] = []
    private var favoriteMoviesArray : [Movie] = []
    private var notFilteredFavoriteMoviesArray : [Movie] = []
    
    func getMovies(category: Constants.category, movieSelection: Constants.MovieSelection) {
        
        guard page <= totalPages || page == 1 else {
            self.view?.limitOfPagesReached()
            return
        }
        
        interactor?.getMovies(page: page, category: category, movieSelection: movieSelection)
        
    }
    
    func numberOfSections() -> Int {
        return moviesArray.count
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return moviesArray.count
    }
    
    func loadMovieWithIndexPath(indexPath: IndexPath) -> Movie {
        return moviesArray[indexPath.row]
    }
    
    func searchByValue(searchText: String) {
        
        guard !searchText.isEmpty else {
            resetArray()
            return
        }
        
        moviesArray = notFilteredArray.filter({ (Movie) -> Bool in
            (Movie.title?.lowercased().contains(searchText.lowercased()))!
        })
        
    }
    
    func resetArray() {
        
        moviesArray = notFilteredArray
        
    }
    
    func showMovie(row: Int) {
        
        let movie = moviesArray[row]
        
        router?.goToMovieDetailsViewController(movie: movie, for: view as! MovieListViewController)
        
    }
    
}

extension MovieListPresenter: MovieListInteractorToPresenterProtocol {
    
    func returnMovieResults(movieHeader: MovieHeader) {
        
        moviesArray += movieHeader.movies ?? []
        notFilteredArray = moviesArray
        page += 1
        totalPages = movieHeader.totalPages ?? 1
        view?.showMovieResults()
        
    }
    
    func problemOnFetchingData(error: errorTypes) {
        
        view?.problemOnFetchingData(error: error)
        
    }
    
}
