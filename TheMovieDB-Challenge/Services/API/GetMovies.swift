//
//  GetMovies.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 25/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    func getMovies(page: Int, category: Constants.category, movieSelection: Constants.MovieSelection, completion : @escaping GenericResponse<MovieHeader>) {
        
        let resourceString = URL(string: "\(Endpoints.getMovies.url)\(movieSelection.rawValue)?api_key=\(Constants.API.privateKey)&language=\(language.rawValue)&page=\(page)")
        
        guard let resourceURL = resourceString else {fatalError("Problema ao obter os dados")}
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, res, err) in
            
            guard let jsonData = data else {
                completion(nil, false, .NoDataAvailable)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                var movieHeader = try decoder.decode(MovieHeader.self, from: jsonData)
                    
                movieHeader.categoryType = movieSelection
                    completion(movieHeader, true, .NoError)
                    
                    if page == 1 {
                        
                        //Pass the number of Pages
                        //self.delegate?.getTotalPages(movieHeader.totalPages ?? 0)
                        
                    }
                    
                    print(String.init(repeating: "-", count: 56) + "API LOG" + String.init(repeating: "-", count: 57))
                    print("Page#\(page) \(resourceURL)")
                    print(String.init(repeating: "-", count: 120));print("")

            }catch {
                
                completion(nil, false, .CanNotProccessData)
                
            }
            
        }
        
        dataTask.resume()
        
    }
    
}
