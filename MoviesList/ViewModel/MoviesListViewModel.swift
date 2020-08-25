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
    private var nextPageToFetch: Int = 1
    private let requester = Requester()

    var moviesDelegate: MoviesListInsertionDelegate?
    
    init() {
        addNewMoviesPage()
    }

    // REVIEW: Method names should be clear about what they do and easy to understand. In this case, the word `add` makes me think I should be passing a value to be added, but the method received no parameters. This indicates the method has side effects, but the method name is not clear as to what they are either. Something like "fetchNextPage" would be more appropriate. Note: you should try to avoid side effects whenever possible ;) it is a code smell and makes the flow of data harder to understand.
    private func addNewMoviesPage() {
        requester.fetchMovies(for: nextPageToFetch) { result in
            switch result {
            case .failure(let error):
                print("Can't load movies: \(error)")
            case .success(let fetchedMovies):
                self.movies.append(contentsOf: fetchedMovies)
                self.nextPageToFetch += 1
                self.moviesDelegate?.moviesListViewModel(self, didInsertMovies: self.movies)
            }
        }
    }
}
