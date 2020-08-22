//
//  MoviesList.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 19/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

protocol MoviesListChangeDelegate {
    func didChangeList(of movies: [Movie])
}

class MoviesList {
    
    var movies: [Movie] = []
    private var nextPageToFetch: Int = 1
    private static let basicURL: String = "https://api.themoviedb.org/3/movie/popular?api_key=2327d278869d309b23954dba04cff77c"
    static let imageURLPrefix: String = "https://image.tmdb.org/t/p/w300"
    var moviesDelegate: MoviesListChangeDelegate?
    
    init() {
        addNewMoviesPage()
    }
    
    private func addNewMoviesPage() {
        fetchMovies { result in
            switch result {
            case .failure(let error):
                print("Can't load movies: \(error)")
            case .success(let fetchedMovies):
                self.movies.append(contentsOf: fetchedMovies)
                self.nextPageToFetch += 1
                self.moviesDelegate?.didChangeList(of: self.movies)
            }
        }
    }
    
    private func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        guard let moviesUrl = URL(string: MoviesList.basicURL + "&page=\(nextPageToFetch)") else { return }
        
        URLSession.shared.dataTask(with: moviesUrl) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }
            do {
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let response = try decoder.decode(TMDBResponse.self, from: data!)
                completion(.success(response.movies))
                
            } catch let decoderError {
                completion(.failure(decoderError))
            }
        }.resume()
    }
}
