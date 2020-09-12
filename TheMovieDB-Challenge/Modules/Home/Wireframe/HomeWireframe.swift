//
//  HomeWireframe.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 24/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

protocol HomeViewToPresenterProtocol: class {
    var view: HomePresenterToViewProtocol? { get set }
    var interactor: HomePresenterToInteractorProtocol? { get set }
    var router: HomePresenterToRouterProtocol? { get set }
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection)
    func numberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func loadMovieArrayWithIndexPath(indexPath: IndexPath) -> [Movie]
    func loadMovieWithIndexPath(indexPath: IndexPath) -> Movie
    func getCategoryName(section: Int) -> String
    func getSelectionWithSection(section: Int) -> Constants.MovieSelection
    func requestFirstCallOfMovies()
}

protocol HomePresenterToInteractorProtocol: class {
    var presenter: HomeInteractorToPresenterProtocol? { get set }
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection)
}

protocol HomeInteractorToPresenterProtocol: class {
    func returnMovieResults(movieHeader: MovieHeader)
    func problemOnFetchingData(error: errorTypes)
}

protocol HomePresenterToViewProtocol: class {
    var presenter: HomeViewToPresenterProtocol? { get set }
    func showMovieResults()
    func problemOnFetchingData(error: errorTypes)
}

protocol HomePresenterToRouterProtocol: class {
    static var mainstoryboard: UIStoryboard { get }
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
