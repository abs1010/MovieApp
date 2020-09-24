//
//  FavoritesRouter.swift
//  TheMovieApp
//
//  Created by Alan Silva on 23/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

class FavoritesRouter: FavoritesPresenterToRouterProtocol {
    
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController {
        
        let withIdentifier = "favoriteStoryboardID"
        
        var mainstoryboard: UIStoryboard {
            let name = "Favorites"
            return UIStoryboard(name: name, bundle: Bundle.main)
        }
        
        guard let view = mainstoryboard.instantiateViewController(withIdentifier: withIdentifier) as? FavoritesViewController else {
            
            print("There was a problem presenting the selected View Controller \(withIdentifier)")
            
            return UIViewController()
        }
        
        view.modalPresentationStyle = presentationStyle
        
        let presenter: FavoritesViewToPresenterProtocol & FavoritesInteractorToPresenterProtocol = FavoritesPresenter()
        let interactor: FavoritesPresenterToInteractorProtocol = FavoritesInteractor()
        let router: FavoritesPresenterToRouterProtocol = FavoritesRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    func goToMovieDetailsViewController(movie: Movie, for view: UIViewController) {
        
        let vc = DetailsRouter.createModule(as: .fullScreen) as! DetailsViewController
        vc.movie = movie
    
        view.present(vc, animated: true, completion: nil)
        
    }
    
}
