//
//  MoviesListView.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 18/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class MoviesListView: UIViewController {
    
    private var viewModel = MoviesListViewModel()
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
        moviesList.backgroundColor = .systemBackground
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

extension MoviesListView: MoviesListInsertionDelegate {
    func moviesListViewModel(_ viewModel: MoviesListViewModel, didInsertMovies movies: [Movie]) {
        let indexPaths = [IndexPath]()
        DispatchQueue.main.async {
            self.moviesList.insertItems(at: indexPaths)
        }
    }
}

// MARK: - UICollectionView

extension MoviesListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // REVIEW: This is a questions of preference, but some people might actually complain about the force unwrap here. In this case, if the casting fails, it means there is an implementation error and the app should really break anyway. There are other scenarios though where you should use a safer approach like `guard let` to unwrap this value. Again, this is a question of preference, but some people have strong opinions and you should know how to explain why in this case, it is not actually a problem to use the force unwrap.
        let cell = moviesList.dequeueReusableCell(withReuseIdentifier: MoviesListView.movieCellIdentifier, for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        cell.title = movie.title
        cell.updateImage(from: movie.imageURL)
        return cell
    }
}

extension MoviesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - (MoviesListView.cellMargin * 2), height: MoviesListView.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        MoviesListView.cellsLineSpacing
    }
    
    // MARK: - UI Constants
    
    private static let cellMargin: CGFloat = 24
    private static let cellHeight: CGFloat = 60
    private static let cellsLineSpacing: CGFloat = 10
}
