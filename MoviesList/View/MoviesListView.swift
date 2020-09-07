//
//  MoviesListView.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 18/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class MoviesListView: UIViewController {
    
    // REVIEW: Ideally, dependencies like the view models would be injected. In this case, setting `MoviesListViewModel()` as the default value is not really a big deal. Although, it should not be hardcoded in a private variable. You should make it "injectable" somehow to improve testability and reduce coupling. As you are instantiating it directly in code, you could make this a constructor parameter.
    // REVIEW: This is just an additional note. You will find that many projects won't follow this practice, but,  to make this really decoupled from the view model type, you should create a protocol and make the concrete type implement that protocol. Anyway, just making it a parameter already makes it more testable.
    private var viewModel: MoviesListViewModel

    init(viewModel: MoviesListViewModel = MoviesListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required override init?(coder: NSCoder) {
        // REVIEW: As I added a new initializer, the compiler will force to add this extra required one. Ideally we'd implement proper support. But you will find that people usually add a fatal error. This approach prevents this controller from being instantiated from storyboard or from being restored if the app is killed by the user or the system. Anyway, this is not usually a problem, but it is good to know. ;)
        fatalError("This is not supported")
        super.init(coder: coder)
    }

    // REVIEW: Namespace for constants
    
    private var moviesList = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        viewModel.moviesDelegate = self
        
        moviesList.delegate = self
        moviesList.dataSource = self
        moviesList.register(MovieCell.self, forCellWithReuseIdentifier: Layout.movieCellIdentifier)
        
        view.addSubview(moviesList)
        moviesList.backgroundColor = .systemBackground
        moviesList.translatesAutoresizingMaskIntoConstraints = false
        
        // REVIEW: Your cells are bing clipped upon rotation. Please investigate.
        NSLayoutConstraint.activate([
            moviesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            moviesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - UI Constants
    // REVIEW: It is a good practice to add a namespace around this kind of constants, just to make their purpose a little more clear. You can use an Enum or Struct for that. My recommendation is to use the Enum. NOTE: `private` members are visible to extensions if they are on the same file.
    private enum Layout {
        static let movieCellIdentifier = "movieCell"
        static let cellMargin: CGFloat = 24
        static let cellHeight: CGFloat = 70
        static let lineSpacing: CGFloat = 10
    }
}

// MARK: - ViewModel Delegate

extension MoviesListView: MoviesListViewModelDelegate {
    // REVIEW: The type that will know for sure what exactly changed, will be the MoviesListViewModel in this case. You should not assume items are only added to the end of the list, because if there is any kind of sorting being applied, that might not be the case. You should make this calculation in the view model and just notify the delegate about the insertions. You don't need the Movie objects here, just the indexes.
    func moviesListViewModel(_ viewModel: MoviesListViewModel, didInsertItemsAt indexPaths: [IndexPath]) {
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
        guard let cell = moviesList.dequeueReusableCell(withReuseIdentifier: Layout.movieCellIdentifier, for: indexPath) as? MovieCell else {
            fatalError("Unable to unwrap collection cell.")
        }
        let movie = viewModel.movies[indexPath.row]
        cell.title = movie.title
        cell.updateImage(from: movie.imageURL)
        return cell
    }
}

extension MoviesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - (Layout.cellMargin * 2), height: Layout.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Layout.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 {
            viewModel.loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetails = MovieDetailsView(movie: viewModel.movies[indexPath.row], requester: Requester.shared)
        navigationController?.pushViewController(movieDetails, animated: true)
    }
}
