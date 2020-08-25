//
//  Requester.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 24/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class Requester {

    static let basicURL: String = "https://api.themoviedb.org/3/movie/popular?api_key=2327d278869d309b23954dba04cff77c"
    static let imageURLPrefix: String = "https://image.tmdb.org/t/p/w300"

    @discardableResult
    func fetchMovies(for page: Int, completion: @escaping (Result<[Movie], Error>) -> ()) -> Cancelable {
        guard let moviesUrl = URL(string: Requester.basicURL + "&page=\(page)") else {
            completion(.failure(FetchError.invalidURL))
            return EmptyTask()
        }

        let request = executeFetch(from: moviesUrl) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)

                    let response = try decoder.decode(TMDBResponse.self, from: data)
                    completion(.success(response.movies))

                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }

        return request
    }

    @discardableResult
    func fetchPosterImage(from imageURL: String, completion: @escaping (Result<UIImage, Error>) -> ()) -> Cancelable {
        guard let fullURL = URL(string: Requester.imageURLPrefix + imageURL) else {
            completion(.failure(FetchError.invalidURL))
            return EmptyTask()
        }

        let request = executeFetch(from: fullURL) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let data):
                guard let fetchedImage = UIImage(data: data) else {
                    completion(.failure(FetchError.imageNotAvailable))
                    return
                }
                completion(.success(fetchedImage))
            }
        }

        return request
    }

    private func executeFetch(from url: URL, completion: @escaping (Result<Data, Error>) -> ()) -> Cancelable {
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                completion(.success(data))
            }
        }

        dataTask.resume()
        return dataTask
    }
}

// MARK: - Cancelable

protocol Cancelable {
    func cancel()
}

extension URLSessionDataTask: Cancelable { }

struct EmptyTask: Cancelable {
    func cancel() {}
}

// MARK: - Fetching errors

enum FetchError: Error {
    case invalidURL
    case imageNotAvailable
}
