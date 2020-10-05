//
//  File.swift
//  TheMovieDB
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

class DetailsRouter: DetailsPresenterToRouterProtocol {
    
    static var mainstoryboard: UIStoryboard {
        let name = "Details"
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController {
        
        let withIdentifier = "DetailsViewControllerID"
        
        guard let view = mainstoryboard.instantiateViewController(withIdentifier: withIdentifier) as? DetailsViewController else {
            
            print("There was a problem presenting the selected View Controller \(withIdentifier)")
            
            return UIViewController()
        }
        
        view.modalPresentationStyle = presentationStyle
        
        let presenter: DetailsViewToPresenterProtocol & DetailsInteractorToPresenterProtocol = DetailsPresenter()
        let interactor: DetailsPresenterToInteractorProtocol = DetailsInteractor()
        let router: DetailsPresenterToRouterProtocol = DetailsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
}
