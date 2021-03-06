//
//  SceneDelegate.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import RealmSwift

public var isAppInBackground = false

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        window?.rootViewController = SplashViewController()
        
    }
    
    /*
    ///Facebook mandatory Method
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application( UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation] )
        
    }
     */
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
/*
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if !isAppInBackground { return }
        
        var presentedView : UIViewController?
        var presentView = self.window?.rootViewController
        repeat {

            presentedView = presentView?.presentedViewController

            if presentedView != nil {
                presentView = presentedView
            }

        } while presentedView != nil

        presentView?.dismiss(animated: false, completion: {
            UIView.animate(withDuration: 0.2, animations: {
                presentView?.view.alpha = 00
            })
        })
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
        if let viewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() {

            var presentedView : UIViewController?
            var presentView = self.window?.rootViewController
            repeat {

                presentedView = presentView?.presentedViewController

                if presentedView != nil {
                    presentView = presentedView
                }

            } while presentedView != nil

            viewController.view.alpha = 0
            presentView?.present(viewController, animated: false, completion: {
                UIView.animate(withDuration: 0.2, animations: {
                    viewController.view.alpha = 1
                })
                isAppInBackground = true
            })
        }
    }
*/
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
    }
    
}
