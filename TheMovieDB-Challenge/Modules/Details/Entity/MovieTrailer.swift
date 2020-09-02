//
//  MovieTrailer.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 01/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - MovieTrailer
struct MovieTrailer: Mappable {

    var id: Int?
    var results: [MovieTrailerElement]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id             <- map["id"]
        results        <- map["results"]
    }

}

// MARK: - MovieTrailerElemente

struct MovieTrailerElement: Mappable {

    var id, iso639, iso3166, key: String?
    var name, site: String?
    var size: Int?
    var type: String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id             <- map["id"]
        iso639         <- map["iso_639_1"]
        iso3166        <- map["iso_3166_1"]
        key            <- map["key"]
        name           <- map["name"]
        site           <- map["site"]
        size           <- map["size"]
        type           <- map["type"]
    }

}
