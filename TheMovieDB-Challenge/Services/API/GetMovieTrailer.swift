//
//  GetMovieTrailer.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 01/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    func getMovieTrailer(movieId: Int, completionHandler: @escaping(Result<MovieTrailer, errorTypes>) -> Void) {
        
        guard let url = URL(string: Endpoints.getMovieTrailer(id: movieId).url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.NoDataAvailable))
                return
            }
            
            guard let jsonData = data else {
                completionHandler(.failure(.NoDataAvailable))
                return
            }
  
//            do {
//                let decodecObject = try JSONDecoder().decode(MovieTrailer.self, from: jsonData)
//
//                completionHandler(.success(decodecObject))
//            }catch {
//                completionHandler(.failure(.CanNotProccessData))
//            }
            
            if let JSONString = String(data: jsonData, encoding: .utf8) {
                guard let decodedObj = MovieTrailer(JSONString: JSONString) else { return }
                completionHandler(.success(decodedObj))
            }
            
        }.resume()
        
    }
    
}
