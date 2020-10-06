//
//  LoginStateService.swift
//  TheMovieApp
//
//  Created by Alan Silva on 05/10/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import GoogleSignIn

class LoginStateService {
    
    static let sharedInstance = LoginStateService()
    
    private init() {}
    
    func isUserLogged() -> Bool {
        ///Google
        guard let signIn = GIDSignIn.sharedInstance() else { return false }
        
        if signIn.hasPreviousSignIn() {
            return true
        }else {
            return false
        }
        
    }
    
}
