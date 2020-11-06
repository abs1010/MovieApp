//
//  File.swift
//  TheMovieApp
//
//  Created by Alan Silva on 21/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

//MARK: - Notification
extension Notification.Name {
    
    static let loginCancelled = Notification.Name("cancelLoginObserver")
    static let loggedInSuccessfully = Notification.Name("successLoginObserver")
    static let loggedOut = Notification.Name("loggedOutObserver")
}
