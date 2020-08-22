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
        // REVIEW: When the type of the property you are assigning to is known, you can reference static methods and properties from the type without specifying it, so you can omit "UIColor" here
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

extension MoviesListView: MoviesListChangeDelegate {
    // REVIEW: This is just a convention, but when you define delegated methods, it is common practice to pass the object that is the source of the event as the first parameter like so 👇
    func moviesListViewModel(_ viewModel: MoviesListViewModel, didChangeMovies movies: [Movie]) {
        DispatchQueue.main.async {
            // REVIEW: It is common to see this kind of approach, but reloading the whole list is not ideal for all scenarios. You should prefer to only reload the items that changed, as it has better performance and the framework handles animations for you. For instance, if you are just loading more items into a list, you could simply notify the collection view of the addition of those items, as the existing items remain the same. More recent frameworks even offer better APIs for that (like IGListKit), but for the pagination example it is quite easy to know what actually changed.
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
        // REVIEW: This is a questions of preference, but some people might actually complain about the force unwrap here. In this case, if the casting fails, it means there is an implementation error and the app should really break anyway. There are other scenarios though where you should use a safer approach like `guard let` to unwrap this value. Again, this is a question of preference, but some people have strong opinions and you should know how to explain why in this case, it is not actually a problem to use the force unwrap.
        let cell = moviesList.dequeueReusableCell(withReuseIdentifier: MoviesListView.movieCellIdentifier, for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        // REVIEW: You should prefer to use simple properties to assign values like this. The way you did is not wrong, but it doesn't look "swifty"
        cell.title = movie.title
        //cell.set(title: movie.title, imageURL: movie.imageURL)
        return cell
    }
}

extension MoviesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 56, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // REVIEW: In Swift 5 we are not required to use the keyword "return" if there is only one expression in the body of the method or closure, but it is, at least for now, still a matter of preference. The only thing you should NOT do is mix both approaches. Choose one way or the other and keep consistency. (Just to make it clear, here you have the "return", but in the method above you dont)
        return 10
    }
}
