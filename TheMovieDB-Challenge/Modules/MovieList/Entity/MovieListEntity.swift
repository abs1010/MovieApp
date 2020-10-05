//
//  Movie.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import RealmSwift

//// MARK: - Genre
//struct Genre: Codable {
//    let genres: [GenreElement]
//}
//
//// MARK: - GenreElement
//struct GenreElement: Codable {
//    let id: Int
//    let name: String
//}
//
class Item: Object {

   @objc dynamic var id: Int = 0
   @objc dynamic var name: String = ""

}

// MARK: - Movie
struct MovieHeader: Codable {
    let page, totalResults, totalPages: Int?
    let movies: [Movie]?
    var categoryType: Constants.MovieSelection?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}

// MARK: - Result
struct Movie: Codable, Hashable {
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var posterPath: String?
    var id: Int?
    var adult: Bool?
    var backdropPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIDS: [Int]?
    var title: String?
    var voteAverage: Double?
    var overview, releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id, adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}

struct IdentifierObject {
    var selection: Constants.MovieSelection
    var section: Int
}
