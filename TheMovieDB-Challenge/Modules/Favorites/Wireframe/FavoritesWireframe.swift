//
//  FavoritesWireframe.swift
//  TheMovieApp
//
//  Created by Alan Silva on 23/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

protocol FavoritesViewToPresenterProtocol: class {
    var view: FavoritesPresenterToViewProtocol? { get set }
    var interactor: FavoritesPresenterToInteractorProtocol? { get set }
    var router: FavoritesPresenterToRouterProtocol? { get set }
    func getFavoriteMovies()
    func getNumberOfRowsInSection(section: Int) -> Int
    func loadMovieWithIndexPath(indexPath: IndexPath) -> Movie
    func searchByValue(searchText: String)
    func resetArray()
    func showMovie(row: Int)
}

protocol FavoritesPresenterToInteractorProtocol: class {
    var presenter: FavoritesInteractorToPresenterProtocol? { get set }
    func getFavoriteMovies()
}

protocol FavoritesInteractorToPresenterProtocol: class {
    func didGetFavoriteMovies(movies: [Movie])
    func FailRequestResults()
}

protocol FavoritesPresenterToViewProtocol: class {
    func showRequestResults()
    func FailRequestResults()
}

protocol FavoritesPresenterToRouterProtocol: class {
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
    func goToMovieDetailsViewController(movie: Movie, for view: UIViewController)
}
