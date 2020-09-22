//
//  DetailsPresenter.swift
//  TheMovieDB
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift
let realm = try! Realm()

class DetailsPresenter: DetailsViewToPresenterProtocol {
    
    var view: DetailsPresenterToViewProtocol?
    var interactor: DetailsPresenterToInteractorProtocol?
    var router: DetailsPresenterToRouterProtocol?
    
    func getAppVersion() {
        
    }
    
}

extension DetailsPresenter: DetailsInteractorToPresenterProtocol {
    
}
