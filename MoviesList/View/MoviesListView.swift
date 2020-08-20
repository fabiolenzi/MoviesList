//
//  MoviesListView.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 18/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class MoviesListView: UIViewController {
    
    private var viewModel = MoviesList()
    private static let movieCellIdentifier = "movieCell"
    
    private var moviesList = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        viewModel.moviesDelegate = self
        
        moviesList.delegate = self
        moviesList.dataSource = self
        moviesList.register(MovieCell.self, forCellWithReuseIdentifier: MoviesListView.movieCellIdentifier)
        
        view.addSubview(moviesList)
        moviesList.backgroundColor = UIColor.systemBackground
        moviesList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moviesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            moviesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - ViewModel Delegate

extension MoviesListView: MoviesListChangeDelegate {
    func didChangeList(of movies: [Movie]) {
        DispatchQueue.main.async {
            self.moviesList.reloadData()
        }
    }
}

// MARK: - UICollectionView

extension MoviesListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesList.dequeueReusableCell(withReuseIdentifier: MoviesListView.movieCellIdentifier, for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        cell.set(title: movie.title)
        return cell
    }
}

extension MoviesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 56, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
