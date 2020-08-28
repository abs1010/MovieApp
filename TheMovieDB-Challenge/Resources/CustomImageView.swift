//
//  CustomImageView.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 22/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageFromURLString(urlString: String, completion: @escaping(Bool) -> Void) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
                completion(true)
            }
            
        }).resume()
    }
    
    func loadUrlImageFromSDWeb(urlString: String, type: Constants.imageType, done: @escaping(Bool) -> Void) {
        
        DispatchQueue.main.async {
            
            let url = NetworkingService.sharedInstance.getUrl(str: urlString, type: type)
            
            self.sd_setImage(with: url, placeholderImage: UIImage(named: "portrait-placeholder"), options: .continueInBackground, progress: .none) { (image, error, cache, url) in
                
                done(true)
                
            }

        }
        
    }
    
}
