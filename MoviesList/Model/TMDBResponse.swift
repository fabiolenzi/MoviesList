//
//  TMDBResponse.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 19/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

struct TMDBResponse: Decodable {
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
