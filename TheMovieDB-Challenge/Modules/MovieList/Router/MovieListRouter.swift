//
//  MovieRouter.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

class MovieListRouter: MovieListPresenterToRouterProtocol {
    
    static var mainstoryboard: UIStoryboard {
        let name = "MovieList"
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController {
        
        let withIdentifier = "MoviesListIdentifier"
        
        guard let view = mainstoryboard.instantiateViewController(withIdentifier: withIdentifier) as? MovieListViewController else {
            
            print("There was a problem presenting the selected View Controller \(withIdentifier)")
            
            return UIViewController()
        }
        
        view.modalPresentationStyle = presentationStyle
        
        let presenter: MovieListViewToPresenterProtocol & MovieListInteractorToPresenterProtocol = MovieListPresenter()
        let interactor: MovieListPresenterToInteractorProtocol = MovieListInteractor()
        let router: MovieListPresenterToRouterProtocol = MovieListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }

}
