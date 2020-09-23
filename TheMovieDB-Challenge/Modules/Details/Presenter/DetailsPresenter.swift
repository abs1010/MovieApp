//
//  DetailsPresenter.swift
//  TheMovieDB
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

class DetailsPresenter: DetailsViewToPresenterProtocol {
    
    var view: DetailsPresenterToViewProtocol?
    var interactor: DetailsPresenterToInteractorProtocol?
    var router: DetailsPresenterToRouterProtocol?
    
    let realm = try! Realm()
    
    func getMovieInfo(for movieId: Int) {
        
        interactor?.getMovieInfo(for: movieId)
        
    }
    
    func isFavorite(_ movieID: Int, completion: @escaping (Bool) -> Void) {
        
        completion(true)
        
//            @IBAction func btnFavoriteTapped(_ sender: UIButton) {
//
//                //verifica status fav / percorre o array e verifica se existe
//
//                if (self.controller?.isFavorite(id: self.movie?.id ?? 0))! {
//
//                    let alerta = UIAlertController(title: "Aviso", message: "Filme removido dos favoritos.", preferredStyle: .alert)
//                    let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//                    alerta.addAction(btnOk)
//
//                    self.present(alerta, animated: true)
//
//                    if let removeId = self.movie?.id {
//
//                        self.controller?.removeFavoriteMovie(id: removeId)
//
//                    }
//
//                    self.setFavButtonStatus()
//
//                }
//                else {
//
//                    let alerta = UIAlertController(title: "Salvo", message: "Filme \(self.movie?.title ?? "") salvo nos favoritos.", preferredStyle: .alert)
//                    let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//                    alerta.addAction(btnOk)
//
//                    self.present(alerta, animated: true)
//
//                    if let selectedMovie = self.movie {
//                        self.controller?.saveFavoriteMovie(movie: selectedMovie)
//                    }
//
//                    self.setFavButtonStatus()
//
//                }
//
//            }
        
    }
    
    func saveAsFavorite(movieID: Int) {
        print("Movie: \(movieID) saved as favorite")
    }
    
}

extension DetailsPresenter: DetailsInteractorToPresenterProtocol {
    
    func didGetMovieInfo(movieDetails: MovieDetails, cast: [CastElement], videoID: String) {
        view?.showRequestResults(movieDetails: movieDetails, cast: cast, videoID: videoID)
    }
    
}

