//
//  AlertService.swift
//  TheMovieApp
//
//  Created by Alan Silva on 05/10/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit

class AlertService: UIView {
    
    static let shared = AlertService()
    
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var topLogoImage: UIImageView!
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertService", owner: self, options: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton(_:)), for: .touchUpInside)
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        
        topLogoImage.layer.cornerRadius = 30
        topLogoImage.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        topLogoImage.layer.shadowRadius = 6.0
        topLogoImage.layer.borderWidth = 2
        
        backgroundImage.layer.shadowColor = UIColor.white.cgColor
        backgroundImage.layer.shadowRadius = 6.0
        
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.coordinateSpace.bounds.width, height: UIScreen.main.coordinateSpace.bounds.height)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    enum topImage: String {
        case success = "Success"
        case failure = "Failure"
    }
    
    func showAlert(image: topImage, title: String, message: String, completion: (() -> Void)? = nil) {
        
        titleLabel.text = title
        messageLabel.text = message
        topLogoImage.image = UIImage(named: image.rawValue)
        
        UIApplication.shared.windows.first {$0.isKeyWindow}?.addSubview(mainView)
        
    }
    
    @objc private func didTapDoneButton(_ : UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.mainView.removeFromSuperview()
        }
        
    }
    
}
