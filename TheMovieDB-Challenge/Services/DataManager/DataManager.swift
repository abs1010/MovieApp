//
//  DataManager.swift
//  theMovieAPP
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

struct DataManager {
    
    static var sharedInstance = DataManager()
    
    let realm = try! Realm()
    private var favoriteMoviesArray : [Movie] = []
    private var notFilteredFavoriteMoviesArray : [Movie] = []
    
    private init() {}
    
    func isFavorite(movieID: Int) -> Bool {
        
        let check = realm.objects(FavoriteMovie.self).filter("id = \(movieID)")
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
    
    func updateFavoriteArray() {
        //self.moviesArray = self.notFilteredArray
    }
    
    //MARK: - Functions for DetailsVC
    
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
    
    mutating func loadFavoriteMovies() -> [Movie] {
        
        let tempFavoriteMovieArray : Results<FavoriteMovie>? = realm.objects(FavoriteMovie.self)
        
        if let array = tempFavoriteMovieArray {
            
            for i in array {
                let title = i.title
                let backdropPath = i.backdropPath
                let overview = i.overview
                let voteAverage = i.voteAverage
                let popularity = i.popularity
                let voteCount = i.voteCount
                let video = i.video
                let posterPath = i.posterPath
                let id = i.id
                let adult = i.adult
                let originalLanguage = i.originalLanguage
                let originalTitle = i.originalTitle
                let releaseDate = i.releaseDate
                
                let movie : Movie = Movie(popularity: popularity, voteCount: voteCount, video: video, posterPath: posterPath, id: id, adult: adult, backdropPath: backdropPath, originalLanguage: originalLanguage, originalTitle: originalTitle, genreIDS: [], title: title, voteAverage: voteAverage, overview: overview, releaseDate: releaseDate)
                                
                self.favoriteMoviesArray.append(movie)
                    
            }
            
        }
        
        return favoriteMoviesArray
        
    }

    func numberOfRowsForFavorites() -> Int {
        
        return self.favoriteMoviesArray.count
        
    }
    
    func loadMovieWithIndexPathForFavorites(indexPath: IndexPath ) -> Movie {
        
        return self.favoriteMoviesArray[indexPath.row]
        
    }
    
}
