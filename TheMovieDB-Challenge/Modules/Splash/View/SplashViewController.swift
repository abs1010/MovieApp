//
//  SplashViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 26/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var animatedImageView: AnimationView!
    @IBOutlet weak var versionLabel: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startTimer()
        startAnimation()
        setVersionLabel()
        
    }
    
    private func setVersionLabel() {
        versionLabel.text = "Versão \(Bundle.main.releaseVersionNumber ?? "-")"
        
        UIView.animate(withDuration: 0.5) {
            self.versionLabel.alpha = 1
        }
        
    }
    
    private func startAnimation() {
        lottieStartAnimation(on: animatedImageView, animationName: .movieClapperboard)
    }
    
    private func startTimer() {
        
        let timeInterval = 4.0
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.endAnimation), userInfo: nil, repeats: false)
        
    }
    
    @objc private func endAnimation() {
        
        lottieStopAnimation(on: animatedImageView)
        timer.invalidate()
        
        DispatchQueue.main.async {
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBar = storyboard.instantiateViewController(withIdentifier: "MainViewControllerIdentifier") as? UITabBarController {
                    let first = HomeRouter.createModule(as: .fullScreen)
                    let second = FavoritesRouter.createModule(as: .fullScreen)
                    let third = UIStoryboard.init(name: "Settings", bundle: Bundle.main).instantiateViewController(withIdentifier: "settingsStoryboardID")
                    //let third = SettingsRouter.createModule(as: .fullScreen)
                    
                    tabBar.viewControllers = [first, second, third]
                    
                    self.present(tabBar, animated: false, completion: nil)
                }
                
            })
        }
    }
    
}
