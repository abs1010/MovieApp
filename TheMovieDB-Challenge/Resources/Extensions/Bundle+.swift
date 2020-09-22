//
//  Bundle+.swift
//  TheMovieApp
//
//  Created by Alan Silva on 21/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
}
