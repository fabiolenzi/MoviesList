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
    private var overviewLabel = UILabel()
    private var scoreLabel = UILabel()
    private var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
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
        
        Requester.shared.fetchPosterImage(from: movie.imageURL, completion: { result in
            switch result {
            case .success(let poster):
                DispatchQueue.main.async {
                    self.posterImage.image = poster
                }
            case .failure(let error):
                print(error)
            }
        })
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        scoreLabel.text = "Score: \(movie.score)" //TODO: Localize it
        
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(overviewLabel)
         
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: MovieDetailsView.posterHeight),
            posterImage.widthAnchor.constraint(equalToConstant: MovieDetailsView.posterWidth),
            posterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MovieDetailsView.viewPadding),
            posterImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.viewPadding),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: MovieDetailsView.viewPadding),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: MovieDetailsView.viewPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: MovieDetailsView.viewPadding),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: MovieDetailsView.titleHeight),
            
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: MovieDetailsView.viewPadding),
            scoreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: MovieDetailsView.viewPadding),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: MovieDetailsView.viewPadding),
            scoreLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: MovieDetailsView.titleHeight),
            
            overviewLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: MovieDetailsView.viewPadding),
            overviewLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: MovieDetailsView.viewPadding),
            overviewLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: MovieDetailsView.viewPadding),
            overviewLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: MovieDetailsView.viewPadding)
        ])
    }
    
    // MARK: - UI Constants
    
    private static let titleHeight: CGFloat = 40
    private static let posterHeight: CGFloat = 80
    private static let posterWidth: CGFloat = 60
    private static let viewPadding: CGFloat = 10
}
