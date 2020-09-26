//
//  DetailsWireframe.swift
//  TheMovieDB
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

protocol DetailsViewToPresenterProtocol: class {
    var view: DetailsPresenterToViewProtocol? { get set }
    var interactor: DetailsPresenterToInteractorProtocol? { get set }
    var router: DetailsPresenterToRouterProtocol? { get set }
    func getMovieInfo(for movieId: Int)
    func isFavorite(_ movieID: Int, completion: @escaping (Bool) -> Void) -> Void
    func saveAsFavorite(movie: Movie?)
    func removeFromFavorites(_ movieID: Int, completion: @escaping (Bool) -> Void) -> Void
    func numberOfItemsInSection() -> Int
    func getCellForItemAt(_ indexPath: IndexPath) -> CastElement
}

protocol DetailsPresenterToInteractorProtocol: class {
    var presenter: DetailsInteractorToPresenterProtocol? { get set }
    func getMovieInfo(for movieId: Int)
}

protocol DetailsInteractorToPresenterProtocol: class {
    func didGetMovieInfo(movieDetails: MovieDetails, credits: Cast, videoID: String)
}

protocol DetailsPresenterToViewProtocol: class {
    func showRequestResults(movieDetails: MovieDetails, crew: [Crew], videoID: String)
}

protocol DetailsPresenterToRouterProtocol: class {
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
