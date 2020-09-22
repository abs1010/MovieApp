//
//  The_MovieDBTests.swift
//  The MovieDBTests
//
//  Created by Alan Silva on 21/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import XCTest
@testable import The_MovieDB

class DetailsViewControllerTests: XCTestCase {
    
    func test_setDurationAsStringUpto60() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(39)
        
        XCTAssertEqual(stringHour, "39m")
        
    }

    func test_setDurationAsStringUpto120() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(107)
        
        XCTAssertEqual(stringHour, "1h 47m")
        
    }
    
    func test_setDurationAsStringUpto180() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(139)
        
        XCTAssertEqual(stringHour, "2h 19m")
        
    }
    
    func test_setDurationAsStringUpto240() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(232)
        
        XCTAssertEqual(stringHour, "3h 52m")
        
    }
    
    func test_setDurationAsStringUpto300() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(297)
        
        XCTAssertEqual(stringHour, "4h 57m")
        
    }
    
    func test_setDurationAsStringUpto360() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(329)
        
        XCTAssertEqual(stringHour, "5h 29m")
        
    }
    
    func test_setDurationAsStringUpto420() {
        
        let sut = DetailsViewController()
        
        let stringHour = sut.setDurationAsString(412)
        
        XCTAssertEqual(stringHour, "6h 52m")
        
    }
    
    func test_fillMovieInfo() {
        /*
        let sut = DetailsViewController()
        
        sut.viewDidLoad()
        
        let movieDetails = MovieDetails(adult: true, backdropPath: nil, belongsToCollection: nil, budget: nil, genres: nil, homepage: nil, id: nil, imdbID: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: nil, posterPath: nil, productionCompanies: nil, productionCountries: nil, releaseDate: nil, revenue: nil, runtime: nil, spokenLanguages: nil, status: nil, tagline: nil, title: "Teste", video: nil, voteAverage: nil, voteCount: nil)
        
        sut.fillMovieInfo(movieDetails)
        
        XCTAssertEqual(movieDetails.title, sut.movieName.text)
        */
    }
    
}
