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
    func getAppVersion()
}

protocol DetailsPresenterToInteractorProtocol: class {
    var presenter: DetailsInteractorToPresenterProtocol? { get set }
}

protocol DetailsInteractorToPresenterProtocol: class {
    
}

protocol DetailsPresenterToViewProtocol: class {
    func DoSomething(_ version: String)
}

protocol DetailsPresenterToRouterProtocol: class {
    static func createModule(as presentationStyle: UIModalPresentationStyle) -> UIViewController
}
