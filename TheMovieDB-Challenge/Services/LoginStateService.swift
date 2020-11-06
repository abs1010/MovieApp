//
//  LoginStateService.swift
//  TheMovieApp
//
//  Created by Alan Silva on 05/10/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit

class LoginStateService {
    
    static let sharedInstance = LoginStateService()
    
    private init() {}
    
    func isUserLogged() -> Bool {
        ///Google
        guard let signIn = GIDSignIn.sharedInstance() else { return false }
        
        if signIn.hasPreviousSignIn() {
            return true
        }else if FBSDKLoginKit.AccessToken.current != nil {
            return true
        }else {
            return false
        }
        
    }
    
    func logOutUser() {
        
        ///Google
        if GIDSignIn.sharedInstance() != nil {
            GIDSignIn.sharedInstance().signOut()
            NotificationCenter.default.post(name: .loggedOut, object: nil)
        }
        
        //Facebook
        if FBSDKLoginKit.AccessToken.current != nil {
            let manager = LoginManager()
            manager.logOut()
            NotificationCenter.default.post(name: .loggedOut, object: nil)
        }
        
        AlertService.shared.showAlert(image: .success, title: "Alert", message: "You have been logged out")
        
    }
    
}
