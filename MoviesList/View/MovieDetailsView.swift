//
//  MovieDetailsView.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 02/09/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class MovieDetailsView: UIViewController {
    
    private var posterImage = UIImageView()
    private var titleLabel = UILabel()
    private var scoreLabel = UILabel()
    private var overviewLabel = UILabel()
    private var movie: Movie
    
    private let requester: Requester

    // REVIEW: You should inject the requester
    init(movie: Movie, requester: Requester = Requester.shared) {
        self.movie = movie
        self.requester = requester
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground

        // REVIEW: You should have a view model your views to handle this kind of logic. As this is a very simple screen, I wouldn't complain in a code review, but this kind of scenario is not really common in real projects, so just keep it in mind ;)
        // REVIEW: Using singletons sometimes make sense. Although, you should avoid referencing them directly like this. You should have it as an injected dependency and stored in a property. Never hardcoded in your method body.
        requester.fetchPosterImage(from: movie.imageURL, completion: { result in
            switch result {
            case .success(let poster):
                DispatchQueue.main.async {
                    self.posterImage.image = poster
                }
            case .failure(let error):
                print(error)
            }
        })

        // REVIEW: It would be better if you separated the layout logic from the populating logic. This method has too many responsibilities.
        titleLabel.text = movie.title
        titleLabel.numberOfLines = 0
        scoreLabel.text = "Score: \(movie.score)" //TODO: Localize it
        overviewLabel.text = movie.overview
        overviewLabel.numberOfLines = 0
        
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(overviewLabel)

        // REVIEW: As I mentioned before, you keep having to repeat this. You could create an extension with a method like `usingAutolayout()` that sets this property to false and returns the view.
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        // REVIEW: This is kind of confusing, I recommend you create the constraints right after you add each view to the hierarchy.
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: MovieDetailsView.posterHeight),
            posterImage.widthAnchor.constraint(equalToConstant: MovieDetailsView.posterWidth),
            posterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MovieDetailsView.viewPadding),
            posterImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.viewPadding),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MovieDetailsView.viewPadding),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: MovieDetailsView.viewPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -MovieDetailsView.viewPadding),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: MovieDetailsView.titleHeight),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: MovieDetailsView.viewPadding),
            scoreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: MovieDetailsView.viewPadding),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -MovieDetailsView.viewPadding),
            scoreLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: MovieDetailsView.titleHeight),
            
            overviewLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: MovieDetailsView.viewPadding),
            overviewLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.viewPadding),
            overviewLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -MovieDetailsView.viewPadding),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -MovieDetailsView.viewPadding)
        ])
    }
    
    // MARK: - UI Constants

    // REVIEW: Namespace for the constants. (Check example in MovieListView)
    private static let titleHeight: CGFloat = 40
    private static let posterHeight: CGFloat = 160
    private static let posterWidth: CGFloat = 120
    private static let viewPadding: CGFloat = 10
}
