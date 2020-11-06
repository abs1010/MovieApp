//
//  LoginInteractor.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 17/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit

class LoginInteractor: NSObject, LoginPresentorToInteractorProtocol {
    
    var view: LoginViewController!
    var presenter: LoginInteractorToPresenterProtocol?
    
    func loginWithProvider(for provider: SocialLoginTypes) {
        
        switch provider {
        case .Apple:
            openLoginWithApple(self.view)
        case .Facebook:
            openLoginWithFacebook(self.view)
        case .Google:
            openLoginWithGoogle(self.view)
        case .Email:
            openLoginWithEmail(self.view)
        }
        
    }
    
    //MARK: - INDIVIDUAL METHODS
    
    private func openLoginWithApple(_ view: UIViewController) {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self.view
        
        controller.performRequests()
        
    }
    
    private func openLoginWithFacebook(_ view: UIViewController) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: view ) { (result, error) -> Void in
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)! {
                    NotificationCenter.default.post(name: .loginCancelled, object: nil)
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    //Login com sucesso. Dismiss a tela de login anterior
                    
                    self.view.dismiss(animated: true, completion: {
                        
                        NotificationCenter.default.post(name: .loggedInSuccessfully, object: nil)
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    private func openLoginWithGoogle(_ view: UIViewController) {
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = view
        
        guard let signIn = GIDSignIn.sharedInstance() else { return }
        
        if (signIn.hasPreviousSignIn()) {
            signIn.signOut()
            
        }
        
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    private func openLoginWithEmail(_ view: UIViewController) {
        
    }
    
}

extension LoginInteractor: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with Google: \(error)")
                NotificationCenter.default.post(name: .loginCancelled, object: nil)
            }
            return
        }
        
        //Login com sucesso. Dismiss a tela de login anterior
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        print(credential)
        
        self.view.dismiss(animated: true, completion: {
            
            NotificationCenter.default.post(name: .loggedInSuccessfully, object: nil)
            
        })
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        guard error == nil else {
            if let error = error {
                print("Failed to disconnect from Google: \(error)")
            }
            return
        }
        
        //        print("Google user was disconnected")
        //        NotificationCenter.default.post(name: .loggedInSuccessfully, object: nil)
        
    }
    
}

extension LoginInteractor: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = LoginSocialEntity()
            
            user.id = credentials.user
            user.GivenName = credentials.fullName?.givenName
            user.FamilyName = credentials.fullName?.familyName
            user.Email = credentials.email
            
        default: break
            
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}
