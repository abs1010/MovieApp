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

/*
 //Methods for Realm
 
 func saveFavoriteMovie(movie: Movie?) {
 
 if let selectedMovie = movie {
 let favorite = FavoriteMovie()
 favorite.title = selectedMovie.title!
 favorite.releaseDate = selectedMovie.releaseDate!
 favorite.overview = selectedMovie.overview!
 favorite.posterPath = selectedMovie.posterPath!
 favorite.backdropPath = selectedMovie.backdropPath!
 favorite.voteAverage = selectedMovie.voteAverage!
 
 for i in movie?.genreIDS ?? [] {
 
 do {
 try self.realm.write {
 let newItem = IntGenreID()
 newItem.id = i
 favorite.items.append(newItem)
 }
 }catch {
 print("Erro ao gravar os dados na base realm")
 }
 
 }
 
 favorite.popularity = selectedMovie.popularity!
 favorite.voteCount = selectedMovie.voteCount!
 favorite.video = selectedMovie.video!
 favorite.id = selectedMovie.id!
 favorite.adult = selectedMovie.adult!
 favorite.originalLanguage = selectedMovie.originalLanguage!
 favorite.originalTitle = selectedMovie.originalTitle!
 
 do {
 try realm.write {
 realm.add(favorite)
 print("Dados salvos no Realm com sucesso")
 }
 } catch {
 print("Erro ao salvar no Realm \(error)")
 }
 
 }
 
 }
 
 func loadFavoriteMovies() {
 
 self.favoriteMoviesArray.removeAll()
 //Realm Array
 var tempFavoriteMovieArray : Results<FavoriteMovie>?
 tempFavoriteMovieArray = realm.objects(FavoriteMovie.self)
 
 if let array = tempFavoriteMovieArray {
 
 for i in array {
 
 let title = i.title
 let backdropPath = i.backdropPath
 let overview = i.overview
 let voteAverage = i.voteAverage
 
 let array = i.items
 
 var genreIDS : [Int]? = []
 
 for i in array {
 
 genreIDS?.append(i.id)
 
 }
 
 let popularity = i.popularity
 let voteCount = i.voteCount
 let video = i.video
 let posterPath = i.posterPath
 let id = i.id
 let adult = i.adult
 let originalLanguage = i.originalLanguage
 let originalTitle = i.originalTitle
 let releaseDate = i.releaseDate
 
 let movie : Movie? = Movie(popularity: popularity, voteCount: voteCount, video: video, posterPath: posterPath, id: id, adult: adult, backdropPath: backdropPath, originalLanguage: originalLanguage, originalTitle: originalTitle, genreIDS: genreIDS, title: title, voteAverage: voteAverage, overview: overview, releaseDate: releaseDate)
 
 self.favoriteMoviesArray.append(movie!)//passou do if let
 //genresArray.removeAll()
 }
 
 print("\(favoriteMoviesArray.count) Filme no array Favoritos")
 print("########")
 notFilteredFavoriteMoviesArray = favoriteMoviesArray
 }
 
 }
 
 //MARK:- VERIFICA SE JA É FAVORITO
 func isFavorite(id: Int) -> Bool {
 
 let check = realm.objects(FavoriteMovie.self).filter("id = \(id)")
 if check.count != 0 {
 return true
 }
 
 return false
 
 }
 
 func removeFavoriteMovie(id: Int) {
 
 let check = realm.objects(FavoriteMovie.self).filter("id = \(id)")
 
 do {
 try realm.write {
 realm.delete(check)
 }
 }
 catch {
 print("Erro ao remover registro : \(error)")
 }
 
 }
 
 */
