//
//  LoginCollectionViewCell.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 14/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
//import SwiftVideoBackground

protocol LoginCollectionViewCellDelegate: class {
    func openLogin()
    func closeView()
}

class LoginCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var loginNowButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: LoginCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
        
    }
    
    private func setupView() {
        
        [loginNowButton, loginButton].forEach { $0.layer.cornerRadius = loginNowButton.frame.height / 2 }
        [loginNowButton, loginButton].forEach { $0.layer.borderWidth = 0.5 }
        [loginNowButton, loginButton].forEach { $0.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)}
        
        loginNowButton.setGradientColor(colorOne: #colorLiteral(red: 0.5389634967, green: 0.8092066646, blue: 0.6423391104, alpha: 1), colorTwo: #colorLiteral(red: 0, green: 0.7066470981, blue: 0.8913161159, alpha: 1))
        
        //try? VideoBackground.shared.play(view: self, videoName: "presentingVideo", videoType: "mp4")
        
    }
    
    @IBAction func signInNowButton(_ sender: UIButton) {
        
        self.delegate?.openLogin()
        
    }
    
    @IBAction func signInLaterButton(_ sender: UIButton) {
        
        self.delegate?.closeView()
        
    }
    
}
