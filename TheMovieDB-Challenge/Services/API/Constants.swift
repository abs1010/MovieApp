//
//  Constants.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 13/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

enum Constants {
    
    enum category : String {
        case Movie = "movie"
        case Series = "serie"
        case Genre = "genre"
        case NoCategory
    }
    
    enum MovieSelection : String {
        
        case Popular = "popular"
        case NowPlaying = "now_playing"
        case Upcoming = "upcoming"
        case TopRated = "top_rated"
        case NoSelection
    }
    
}

public enum imageType {
    case banner
    case cover
}
