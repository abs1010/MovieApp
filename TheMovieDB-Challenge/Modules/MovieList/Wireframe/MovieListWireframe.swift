//
//  MovieWireframe.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

protocol MovieListViewToPresenterProtocol: class {
    var view: MovieListPresenterToViewProtocol? { get set }
    var interactor: MovieListPresenterToInteractorProtocol? { get set }
    var router: MovieListPresenterToRouterProtocol? { get set }
    func getMovies(category: Constants.category, movieSelection: Constants.MovieSelection)
    func numberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func loadMovieWithIndexPath(indexPath: IndexPath) -> Movie
}

protocol MovieListPresenterToInteractorProtocol: class {
    var presenter: MovieListInteractorToPresenterProtocol? { get set }
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection)
}

protocol MovieListInteractorToPresenterProtocol: class {
    func returnMovieResults(movieHeader: MovieHeader)
    func problemOnFetchingData(error: errorTypes)
}

protocol MovieListPresenterToViewProtocol: class {
    var presenter: MovieListViewToPresenterProtocol? { get set }
    func showMovieResults()
    func problemOnFetchingData(error: errorTypes)
    func limitOfPagesReached()
}

protocol MovieListPresenterToRouterProtocol: class {
    static var mainstoryboard: UIStoryboard { get }
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
