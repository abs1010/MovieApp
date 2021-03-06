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
        //imageView.backgroundColor = .white
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        //label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 10.5)
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let characterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 9.0, weight: .medium)
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let bottomView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(cast: CastElement, item: Int) {
        
//        if item == 8 {
//
//            nameLabel.text = "View More"
//            characterLabel.text = "⇢"
//            profilePic.image = nil
//
//            NSLayoutConstraint.activate([
//                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//                nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
//                characterLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
//            ])
//
//            return
//
//        }
        
        if let path = cast.profilePath {
            profilePic.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w200/\(path)"), placeholderImage: UIImage(named: "movie-placeholder"), completed: nil)
        }else {
            profilePic.image = UIImage(named: "movie-placeholder")
        }
        
        nameLabel.text = cast.name
        characterLabel.text = "\(cast.character ?? "")"
        
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
        profilePic.addSubview(bottomView)
        bottomView.addSubview(nameLabel)
        bottomView.addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            //nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            characterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            characterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            
            bottomView.heightAnchor.constraint(equalToConstant: 35),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            profilePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            profilePic.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            profilePic.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            profilePic.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
        
        //let bottom = characterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        //bottom.isActive = true
        //bottom.priority = UILayoutPriority(999.0)
        
    }
    
}
