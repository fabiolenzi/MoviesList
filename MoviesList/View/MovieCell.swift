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
    
    private func setupView() {
        backgroundColor = UIColor.systemGray3
        layer.cornerRadius = 10
        
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
