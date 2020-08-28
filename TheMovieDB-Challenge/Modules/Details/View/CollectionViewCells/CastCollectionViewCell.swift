//
//  CollectionViewCell.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 27/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "CastCollectionViewCellID"
    
    let profilePic: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        
        return label
    }()
    
    let characterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(cast: CastElement) {
        
        profilePic.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w200/\(cast.profilePath ?? "")"), placeholderImage: UIImage(named: "placeholder"), completed: nil)
        
        nameLabel.text = cast.name
        characterLabel.text = cast.character
        
    }
    
    private func setUpConstraintsAndLayout() {
        
        self.backgroundColor = .white
        
        layer.cornerRadius = 6.0
        
        addSubview(profilePic)
        addSubview(nameLabel)
        addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            characterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            characterLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            nameLabel.bottomAnchor.constraint(equalTo: characterLabel.topAnchor, constant: -5),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            profilePic.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            profilePic.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            profilePic.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5)
            //profilePic.heightAnchor.constraint(equalToConstant: 80),
        ])
        
    }
    
}
