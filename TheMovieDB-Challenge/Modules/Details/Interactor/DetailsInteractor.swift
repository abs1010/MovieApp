//
//  DetailsInteractor.swift
//  theMovieAPP
//
//  Created by Alan Silva on 22/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

class DetailsInteractor: DetailsPresenterToInteractorProtocol {
    
    weak var presenter: DetailsInteractorToPresenterProtocol?
    
    private var movieDetails: MovieDetails? = nil
    private var cast = [CastElement]()
    private var videoID = ""
    
    func getMovieInfo(for movieId: Int) {
        
        //Creates a Group Dispatch to handle all calls
        let group = DispatchGroup()
        
        group.enter()
        NetworkingService.sharedInstance.getMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                print("Task 1 has Finished")
                self?.movieDetails = movieDetails
            case .failure(let error):
                print(error)
            }
            
            group.leave()
            
        }
        
        group.enter()
        NetworkingService.sharedInstance.getMovieCast(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let castArray):
                print("Task 2 has Finished")
                self?.cast = castArray.cast ?? []
            case .failure(let error):
                print(error)
            }
            
            group.leave()
            
        }
        
        group.enter()
        NetworkingService.sharedInstance.getMovieTrailer(movieId: movieId) { [weak self] result in
            
            switch result {
            case .success(let trailer):
                print("Task 3 has Finished")
                
                if let videoID = trailer.results?.first?.key {
                    
                    self?.videoID = videoID
                    
                }
            case .failure(let error):
                print(error)
            }
            
            group.leave()
            
        }
        
        //The group has finished all tasks
        group.notify(queue: .main) {
            guard let mvDetails = self.movieDetails else { return }
            self.presenter?.didGetMovieInfo(movieDetails: mvDetails, cast: self.cast, videoID: self.videoID)
        }
        
    }
    
}
