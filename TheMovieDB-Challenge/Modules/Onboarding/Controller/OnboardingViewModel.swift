//
//  OnboardingViewModel.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 13/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class OnboardingViewModel {
    
    //ArrayOfPages for Onborading
    let pages: [Page] = {
        
        let firstPage = Page(title: "See what's trending", message: "You can see what's new in theaters, as well as popular and top-rated movies.", imageName: "pg8")
        
        let secondPage = Page(title: "Save your favorites", message: "Tap to save any item, whether a movie or a serie to see it later.", imageName: "pg5")
        
        let thirdPage = Page(title: "See what is waiting for you", message: "Watch trailers and other people's reviews before going to the cinema.", imageName: "pg7")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    func getArrayOfPages() -> [Page] {
        
        return pages
        
    }
    
    func getNumberOfItems() -> Int {
        
        return self.pages.count
        
    }
    
    func getPageWithIndex(for index: IndexPath) -> Page {
        
        return self.pages[index.item]
        
    }
    
}
