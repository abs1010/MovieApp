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
    private var credits: Cast?
    private var videoID = ""
    
    func getMovieInfo(for movieId: Int) {
        
        //Creates a Group Dispatch to handle all calls
        let group = DispatchGroup()
        
        group.enter()
        NetworkingService.sharedInstance.genericRequest(endpoint: .getMovieDetails(id: movieId)) { [weak self] (result: Result<MovieDetails, errorTypes>) in
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
        
        NetworkingService.sharedInstance.genericRequest(endpoint: .getMovieCast(id: movieId)) { [weak self] (result: Result<Cast, errorTypes>) in
            switch result {
            case .success(let castArray):
                print("Task 2 has Finished")
                self?.credits = castArray
            case .failure(let error):
                print(error)
            }
            
            group.leave()
            
        }
        
        group.enter()
        NetworkingService.sharedInstance.genericRequest(endpoint: .getMovieTrailer(id: movieId)) { [weak self] (result: Result<MovieTrailer, errorTypes>) in
            
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
            print("The group has finished all tasks")
            guard let mvDetails = self.movieDetails else { return }
            guard let credits = self.credits else { return }
            self.presenter?.didGetMovieInfo(movieDetails: mvDetails, credits: credits, videoID: self.videoID)
        }
        
    }
    
}
