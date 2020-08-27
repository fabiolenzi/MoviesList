//
//  MovieCell.swift
//  MoviesList
//
//  Created by Fábio Lenzi on 20/08/20.
//  Copyright © 2020 Fábio Lenzi. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    private var titleLabel = UILabel()
    private var posterImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    func updateImage(from url: String) {
        Requester.shared.fetchPosterImage(from: url) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")

            case .success(let image):
                DispatchQueue.main.async {
                    self.posterImage.image = image
                }
            }
        }
    }

    private func setupView() {
        backgroundColor = .systemGray3
        posterImage.layer.masksToBounds = true
        posterImage.layer.cornerRadius = MovieCell.posterImageCornerRadius
        layer.cornerRadius = MovieCell.cellCornerRadius

        addSubview(titleLabel)
        addSubview(posterImage)
        titleLabel.font = UIFont.systemFont(ofSize: MovieCell.movieTitleFontSize)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImage.heightAnchor.constraint(equalToConstant: MovieCell.posterImageHeight),
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: MovieCell.cellPadding),
            posterImage.widthAnchor.constraint(equalToConstant: MovieCell.posterImageWidth),
            titleLabel.heightAnchor.constraint(equalToConstant: MovieCell.movieTitleHeight),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: MovieCell.cellPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -MovieCell.cellPadding)
        ])
    }

    // MARK: - UI Constants

    private static let posterImageHeight: CGFloat = 50
    private static let posterImageWidth: CGFloat = 40
    private static let posterImageCornerRadius: CGFloat = 5
    private static let cellCornerRadius: CGFloat = 10
    private static let cellPadding: CGFloat = 12
    private static let movieTitleHeight: CGFloat = 20
    private static let movieTitleFontSize: CGFloat = 16
}
