//
//  Cast.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 27/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

// MARK: - Cast
struct Cast: Codable {
    let movieID: Int?
    let cast: [CastElement]?
    let crew: [Crew]?
    
    enum CodingKeys: String, CodingKey {
        case movieID = "id"
        case cast
        case crew
    }
}

// MARK: - CastElement
struct CastElement: Codable {
    let castID: Int?
    let character, creditID: String?
    let gender, id: Int?
    let name: String?
    let order: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
    
    init() {
        self.castID = 0
        self.character = ""
        self.creditID = ""
        self.gender = 0
        self.id = 0
        self.name = ""
        self.order = 0
        self.profilePath = ""
    }
    
}

// MARK: - Crew
struct Crew: Codable, Hashable {
    let creditID, department: String?
    let gender, id: Int?
    let job, name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}
