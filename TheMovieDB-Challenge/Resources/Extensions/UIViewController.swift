//
//  Extensions.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 01/02/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import Lottie

//MARK: - Lottie
extension UIViewController {

    public enum animationFile : String {
        case movieLoading = "1961-movie-loading"
        case videoPlayback = "19404-video-playback"
        case movieClapperboard = "19117-movie-clapperboard"
        case movieEngagement = "31162-movie-engagement"
        case wow = "2086-wow"
        case empty = "13525-empty"
        case ladySearching = "16702-lady-searching"
        case notFound = "10687-not-found"
    }
    
    public func lottieStartAnimation(on uiview: AnimationView, animationName: animationFile) {
        
        let animation = Animation.named(animationName.rawValue)
        uiview.animation = animation
        uiview.loopMode = .loop
        uiview.play()
        
    }
    
    public func lottieStopAnimation(on uiview: AnimationView) {
        
        uiview.stop()
        uiview.animation = nil
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
