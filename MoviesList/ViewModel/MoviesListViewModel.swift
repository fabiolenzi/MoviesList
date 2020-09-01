//
//  MoviesListViewModel.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 24/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

protocol MoviesListInsertionDelegate {
    func moviesListViewModel(_ viewModel: MoviesListViewModel, didInsertMovies movies: [Movie])
}

class MoviesListViewModel {

    private(set) var movies: [Movie] = []
    private let amountOfMoviesPerPage: Int = 20
    private var nextPageToFetch: Int {
        get {
            let next = (movies.count / amountOfMoviesPerPage) + 1
            return next
        }
    }

    var moviesDelegate: MoviesListInsertionDelegate?
    
    init() {
        loadNextPage()
    }
    
    func loadNextPage() {
        loadMovies(for: nextPageToFetch)
    }
    
    private func loadMovies(for page: Int) {
        Requester.shared.fetchMovies(for: page) { result in
            switch result {
            case .failure(let error):
                print("Can't load movies: \(error)")
            case .success(let movies):
                self.movies.append(contentsOf: movies)
                self.moviesDelegate?.moviesListViewModel(self, didInsertMovies: self.movies)
            }
        }
    }
    
    
}
