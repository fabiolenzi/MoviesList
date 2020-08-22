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

    // REVIEW: This should be a property. `set` looks javaish
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue } // REVIEW: "newValue" is a keyword in this context
    }
    
    private func fetchPosterImage(for imageURL: String) {
        guard let fullURL = URL(string: MoviesList.imageURLPrefix + imageURL) else { return }
        URLSession.shared.dataTask(with: fullURL) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error)")
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemGray3
        posterImage.layer.masksToBounds = true
        posterImage.layer.cornerRadius = 5
        layer.cornerRadius = 10
        
        addSubview(titleLabel)
        addSubview(posterImage)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            posterImage.widthAnchor.constraint(equalToConstant: 60),
            posterImage.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
