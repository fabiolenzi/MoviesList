//
//  Movie.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 19/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let id: Int
    let title: String
    let imageURL: String
    let overview: String
    let score: Double
    let releaseDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "poster_path"
        case overview
        case score = "vote_average"
        case releaseDate = "release_date"
    }
}
