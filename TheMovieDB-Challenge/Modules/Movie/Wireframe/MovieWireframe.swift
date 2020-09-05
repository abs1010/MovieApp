//
//  MovieWireframe.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 04/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

protocol MovieViewToPresenterProtocol: class {
    var view: MoviePresenterToViewProtocol? { get set }
    var interactor: MoviePresenterToInteractorProtocol? { get set }
    var router: MoviePresenterToRouterProtocol? { get set }
    func getAppVersion()
}

protocol MoviePresenterToInteractorProtocol: class {
    var presenter: MovieInteractorToPresenterProtocol? { get set }
    func request()
}

protocol MovieInteractorToPresenterProtocol: class {

}

protocol MoviePresenterToViewProtocol: class {
    
}

protocol MoviePresenterToRouterProtocol: class {
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
