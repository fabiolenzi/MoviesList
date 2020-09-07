//
//  MoviesListViewModel.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 24/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

// REVIEW: I would rename this to `MoviesListViewModelDelegate`. You might want to have additional methods here and this would require you to create a new protocol or change the name of this one. Usually when you are going MVVM you have to find a way to make events in the `view model` trigger changes in the `view`. Delegation is one approach but conventionally, the delegate protocol name is linked to the type that requires a delegate, not the type of the delegate.
protocol MoviesListViewModelDelegate {
    func moviesListViewModel(_ viewModel: MoviesListViewModel, didInsertItemsAt indexPaths: [IndexPath])
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

    var moviesDelegate: MoviesListViewModelDelegate?
    
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

                // REVIEW: You can calculate the index paths here and pass only the indexes to the delegate
                let initialIndex = self.movies.count - movies.count
                let indexPaths = movies.enumerated().map { (index, _) in
                    IndexPath(item: (initialIndex + index), section: 0)
                }

                self.moviesDelegate?.moviesListViewModel(self, didInsertItemsAt: indexPaths)
            }
        }
    }
}
