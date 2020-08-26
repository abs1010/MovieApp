//
//  DetailsViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift
import FirebaseCrashlytics
import AVKit
import AVFoundation

//import Hero

class DetailsViewController: UIViewController {
    
    let realm = try! Realm()
    var genreIDS : Results<Item>?
    
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: CustomImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieTagline: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var roundedView: UIView!
    
    let shapeLayer = CAShapeLayer()
    
    var movie : Movie? {
        
        didSet {
            
            LoadingView.sharedInstance.show(style: .dark)
            
            loadGenres()
            
        }
        
    }
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCell()
        
    }
    
    private func setScore(rating: Int) {
        
        let center = CGPoint(x: 38.0, y: 38.0)
        let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.8242291808, green: 0.8366972804, blue: 0.1931050718, alpha: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor // #colorLiteral(red: 0.03029535897, green: 0.1094857976, blue: 0.1347175539, alpha: 1)
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        
        scoreView.layer.addSublayer(shapeLayer)
        roundedView.layer.cornerRadius = roundedView.frame.width / 2
        
        perform(#selector(animateScore), with: nil, afterDelay: 0.5)
        
    }
    
    @objc private func animateScore() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    @IBAction func tappedGoBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        
        let selectedVideo = Bundle.main.path(forResource: "presentingVideo", ofType: "mp4")
        
        let videoPath = URL(fileURLWithPath: selectedVideo ?? "")
        
        player = AVPlayer(url: videoPath)
        playerViewController.player = player
        
        self.present(playerViewController, animated: true, completion: {
            self.player.play()
        })
        
    }
    
    private func loadGenres() {
        
        genreIDS = realm.objects(Item.self)
        
    }
    
    private func setGenres(idArray: [Int]?) -> String {
        
        if let id = idArray {
            
            if id.count != 0 {
                
                var genresByName = ""
                
                //percorre os IDS
                for genreCodes in id {
                    //Percorre o Movie em busca do ID
                    if let categoryForDeletion = self.genreIDS {
                        
                        for search in categoryForDeletion {
                            
                            if search.id == genreCodes {
                                genresByName.append(search.name + ", ")
                            }
                            
                        }
                    }
                    
                }
                
                //let size = (genresByName.count - 2)
                //let str = genresByName[0..<size] + "."
                
                return genresByName
                
            }
            
        }
        
        return "Não foi possivel identificar generos."
    }
    
    //    func setFavButtonStatus(){
    //        if let resp = self.controller?.isFavorite(id: movie?.id ?? 0) {
    //
    //            if resp == true {
    //                self.btnFavorite.setImage(#imageLiteral(resourceName: "filledHeart_icon") , for: .normal)
    //            }
    //            else{
    //                self.btnFavorite.setImage(#imageLiteral(resourceName: "emptyHeart_icon") , for: .normal)
    //            }
    //        }
    //    }
    
    private func setupCell() {
        
        if let movieId = movie?.id {
            NetworkingService.sharedInstance.getMovieDetails(movieId: movieId) { [weak self] result in
                
                switch result {
                case .success(let movieDetails):
                    
                    DispatchQueue.main.async {
                        self?.movieTagline.text = movieDetails.tagline ?? ""
                        self?.movieRating.text = "\(movieDetails.voteAverage ?? 0.0)℅".replacingOccurrences(of: ".", with: "")
                    }
                    
                    LoadingView.sharedInstance.hide()
                case .failure(let error):
                    print(error)
                }
                
            }
            
        }
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        ///Make a circle for the score View
        favoriteView.layer.cornerRadius = favoriteView.frame.width / 2
        
        //self.setFavButtonStatus()
        
        if let urlString = self.movie?.backdropPath {
            self.backgroundImage.loadUrlImageFromSDWeb(urlString: urlString, type: .cover, done: { isLoadFinished in
                
                if isLoadFinished {
                    
                    //self?.imgLoadActivityIndicator.stopAnimating()
                    
                }
                
            })
            
        }else {
            self.backgroundImage.image = UIImage(named: "placeholder")
        }
        
        movieName.text = movie?.title
        moviePlot.text = movie?.overview
        movieGenre.text = setGenres(idArray: movie?.genreIDS ?? [])
        
        setScore(rating: movie?.voteCount ?? 50)
        
    }
    
    //    @IBAction func btnFavoriteTapped(_ sender: UIButton) {
    //
    //        //verifica status fav / percorre o array e verifica se existe
    //
    //        if (self.controller?.isFavorite(id: self.movie?.id ?? 0))! {
    //
    //            let alerta = UIAlertController(title: "Aviso", message: "Filme removido dos favoritos.", preferredStyle: .alert)
    //            let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
    //
    //            alerta.addAction(btnOk)
    //
    //            self.present(alerta, animated: true)
    //
    //            if let removeId = self.movie?.id {
    //
    //                self.controller?.removeFavoriteMovie(id: removeId)
    //
    //            }
    //
    //            self.setFavButtonStatus()
    //
    //        }
    //        else {
    //
    //            let alerta = UIAlertController(title: "Salvo", message: "Filme \(self.movie?.title ?? "") salvo nos favoritos.", preferredStyle: .alert)
    //            let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
    //
    //            alerta.addAction(btnOk)
    //
    //            self.present(alerta, animated: true)
    //
    //            if let selectedMovie = self.movie {
    //                self.controller?.saveFavoriteMovie(movie: selectedMovie)
    //            }
    //
    //            self.setFavButtonStatus()
    //
    //        }
    //
    //    }
    
}
