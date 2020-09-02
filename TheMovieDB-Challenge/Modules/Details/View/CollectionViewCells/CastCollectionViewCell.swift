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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        //label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let characterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        //label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(cast: CastElement, item: Int) {
        
        if item == 8 {
            
            nameLabel.text = "View More"
            characterLabel.text = "⇢"
            profilePic.image = nil
            
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                characterLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
            
            return
            
        }
        
        profilePic.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w200/\(cast.profilePath ?? "")"), placeholderImage: UIImage(named: "placeholder"), completed: nil)
        
        //nameLabel.text = cast.name
        //characterLabel.text = cast.character
        
    }
    
    private func setUpConstraintsAndLayout() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white
        
        layer.cornerRadius = 6.0
        
        layer.shadowRadius = 5
        layer.shadowOpacity = 2.3
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 8)
        profilePic.layer.cornerRadius = 6.0
        
        addSubview(profilePic)
        addSubview(nameLabel)
        addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
//            characterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            characterLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//
//            nameLabel.bottomAnchor.constraint(equalTo: characterLabel.topAnchor, constant: -5),
//            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            profilePic.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            profilePic.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            profilePic.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
    }
    
}
