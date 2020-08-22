//
//  MoviesList.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 19/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import Foundation

protocol MoviesListChangeDelegate {
    // REVIEW: See my comment on the caller about this method signature
    func didChangeList(of movies: [Movie])
}

// REVIEW: The name `MoviesList` is kind of misleading. It makes me think this is an array or list of some kind. The name of a class should be clear about it is and its purpose. When we are working with MVVM it is common to append `ViewModel` to the name of the class.
class MoviesListViewModel {

    // REVIEW: This property being public means anybody can change it outside of this class. I don't think this should happen, right? To fix it, you can make the setter private like this 👇
    private(set) var movies: [Movie] = []
    private var nextPageToFetch: Int = 1

    // REVIEW: I know this is a very simple example, but by making this class responsible for fetching and parsing the data in addition to preparing the data to be presented by the view, you are breaking the single responsibility principal. I understand that in such a simple project, this would be acceptable, but you should be aware that for real projects it is usually not a good idea.
    private static let basicURL: String = "https://api.themoviedb.org/3/movie/popular?api_key=2327d278869d309b23954dba04cff77c"
    // REVIEW: Constants like the above, should be kept in a separate file or even read from configuration files and fed to the service classes as needed. Having them hardcoded in the class like this makes them harder to find and your code harder do maintain.
    static let imageURLPrefix: String = "https://image.tmdb.org/t/p/w300"

    var moviesDelegate: MoviesListChangeDelegate?
    
    init() {
        addNewMoviesPage()
    }

    // REVIEW: Method names should be clear about what they do and easy to understand. In this case, the word `add` makes me think I should be passing a value to be added, but the method received no parameters. This indicates the method has side effects, but the method name is not clear as to what they are either. Something like "fetchNextPage" would be more appropriate. Note: you should try to avoid side effects whenever possible ;) it is a code smell and makes the flow of data harder to understand.
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
    
    private func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> ()) -> Cancellable {
        guard let moviesUrl = URL(string: MoviesList.basicURL + "&page=\(nextPageToFetch)") else { return }

        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: moviesUrl) { (data, _, error) in
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
        // REVIEW: Good data fetching APIs should always make the operations cancellable. If you start downloading the thumbnail for a cell and the users scrolls that cell out of the screen, you don't want to complete the download, as it would be a waste of resources. You could create a "Cancellable" protocol and return the task from this method so, if it is necessary, the user of the API can use the "Cancellable" reference to cancel the download. In this case would just need to create the protocol with the `cancel()` method and make the data task implement it as it already has this method. Then you return the task right after you call `resume()`. You might think you can change the return type to URLSessionDataTask but then you are exposing the dependencies of your class and this serves no purpose in this case.
        }

        dataTask.resume()

        return dataTask
    }
}

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {}
