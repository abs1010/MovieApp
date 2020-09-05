//
//  MoviePresenter.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class MoviePresenter: MovieViewToPresenterProtocol {

    var view: MoviePresenterToViewProtocol?
    var interactor: MoviePresenterToInteractorProtocol?
    var router: MoviePresenterToRouterProtocol?
    
    func getAppVersion() {
        
    }
    
}
