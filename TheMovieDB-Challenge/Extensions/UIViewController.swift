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
        case movieLoading1 = "1961-movie-loading"
        case movieLoading2 = "19404-video-playback"
        case movieLoading3 = "19117-movie-clapperboard"
        case movieLoading4 = "31162-movie-engagement"
    }
    
    public func lottieStartAnimation(on uiview: AnimationView, animationFileName: animationFile) {
        
        let animation = Animation.named(animationFileName.rawValue)
        uiview.animation = animation
        uiview.loopMode = .loop
        uiview.play()
        
    }
    
    public func lottieStopAnimation(on uiview: AnimationView) {
        
        uiview.stop()
        uiview.animation = nil
        
    }
    
}
