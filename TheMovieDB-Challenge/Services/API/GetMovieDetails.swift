//
//  MovieDetails.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 25/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, errorTypes>) -> Void) {
        
        guard let url = URL(string: Endpoints.getMovieID(id: movieId).url) else { return }
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            //print(String(data: data, encoding: .utf8)!)
            
            do {
                let decodedObj = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(decodedObj))
                
            }catch {
                completion(.failure(.CanNotProccessData))
            }
                
            semaphore.signal()
        
        }
        
        task.resume()
        semaphore.wait()
        
    }
    
}