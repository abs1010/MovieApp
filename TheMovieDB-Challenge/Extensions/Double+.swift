//
//  File.swift
//  TheMovieApp
//
//  Created by Alan Silva on 21/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

//MARK: - Double
extension Double {
    func toStringWithStar() -> String {
        return "⭐️ " + String(format: "%.1f",self)
    }
}

