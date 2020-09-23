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
    func isFavorite(_ movieID: Int, completion: @escaping(Bool) -> Void) -> Void
    func saveAsFavorite(movieID: Int)
}

protocol DetailsPresenterToInteractorProtocol: class {
    var presenter: DetailsInteractorToPresenterProtocol? { get set }
    func getMovieInfo(for movieId: Int)
}

protocol DetailsInteractorToPresenterProtocol: class {
    func didGetMovieInfo(movieDetails: MovieDetails, cast: [CastElement], videoID: String)
}

protocol DetailsPresenterToViewProtocol: class {
    func showRequestResults(movieDetails: MovieDetails, cast: [CastElement], videoID: String)
}

protocol DetailsPresenterToRouterProtocol: class {
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
