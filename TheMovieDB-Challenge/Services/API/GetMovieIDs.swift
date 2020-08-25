//
//  GetMovieIDs.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 25/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    //MARK: - Genre id request
     
     func getGenreIds(completion: @escaping(Genre) -> Void) {
         
         let resourceURL = "\(Constants.API.baseURL)\(Constants.category.Genre.rawValue)/movie/list?api_key=\(Constants.API.privateKey)&language=\(language)"
         
         guard let url = URL(string: resourceURL) else { return }
         
         URLSession.shared.dataTask(with: url) { (data, response, err) in
             
             guard let jsonData = data else {
                 return
             }
             
             do {
                 
                 let genres = try JSONDecoder().decode(Genre.self, from: jsonData)
                 
                 completion(genres)
                 
             }catch {
                 print("Erro ao obter Generos")
             }
             
         }.resume()
         
     }
    
}
