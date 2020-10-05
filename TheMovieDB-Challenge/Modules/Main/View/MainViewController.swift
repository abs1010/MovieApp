//
//  ViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private lazy var underlineColor: UIColor = {
        return #colorLiteral(red: 0.1098660156, green: 0.109588854, blue: 0.1179477498, alpha: 1)//#colorLiteral(red: 0.004975964781, green: 0.1413759589, blue: 0.2588710785, alpha: 1)
    }()
    
    private var underlineHeight: CGFloat = 3.0
    private var minimumTabBarHeight: CGFloat = 65.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let items = tabBar.items else { return }

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPadding: CGFloat = window?.safeAreaInsets.bottom ?? 0.0
        
        if tabBar.frame.size.height < 60 {
            tabBar.frame.size.height = minimumTabBarHeight
            tabBar.frame.origin.y = view.frame.height - minimumTabBarHeight
            
            tabBar.items?.forEach({
                $0.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
                $0.imageInsets = UIEdgeInsets.init(top: -4, left: 0, bottom: 4, right: 0)
            })
        }
        
        let selectionIndicatorImage = UIImage().createSelectionIndicator(
            color: underlineColor,
            size: CGSize(width: tabBar.frame.width / CGFloat(items.count),
                         height: tabBar.frame.height - bottomPadding),
            lineHeight: underlineHeight
        )
        
        tabBar.selectionIndicatorImage = selectionIndicatorImage
        
    }

}

fileprivate extension UIImage {
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let rect = CGRect(x: 0, y: size.height - lineHeight, width: size.width, height: lineHeight)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
