//
//  File.swift
//  TheMovieApp
//
//  Created by Alan Silva on 21/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

//MARK: - UserDefaults
extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func isFirstUse() -> Bool {
        
        return bool(forKey: "isFirstUse")
        
    }
    
    func setFirstUse(_ value: Bool) {
        set(value, forKey: "isFirstUse")
        synchronize()
    }
}
