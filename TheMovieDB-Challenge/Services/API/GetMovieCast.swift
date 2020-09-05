//
//  GetMovieCast.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 27/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    func getMovieCast(movieId: Int, completionHandler: @escaping(Result<Cast, errorTypes>) -> Void) {
        
        guard let url = URL(string: Endpoints.getMovieCast(id: movieId).url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.NoDataAvailable))
                return
            }
            
            guard let jsonData = data else {
                completionHandler(.failure(.NoDataAvailable))
                return
            }
            
            do {
                let decodedObj = try JSONDecoder().decode(Cast.self, from: jsonData)
                
                completionHandler(.success(decodedObj))
                
            }catch {
                completionHandler(.failure(.CanNotProccessData))
            }
            
            self.showApiLog(url.absoluteString)
            
        }.resume()
        
    }
    
}
