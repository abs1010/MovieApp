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
import YouTubePlayer

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: CustomImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieTagline: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var videoPlayerViewHeightConstraint: NSLayoutConstraint!
    
    let realm = try! Realm()
    var castArray: [CastElement]?
    let shapeLayer = CAShapeLayer()
    var movie : Movie?
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollection()
        setupCell()
        setupVideoDelegate()
        
    }
    
    @IBAction func tappedGoBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func setUpCollection() {
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCellID")
        castCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupVideoDelegate() {
        
        videoPlayer.delegate = self
        
    }
    
    private func setupCell() {
        
        //self.setFavButtonStatus()
        
        LoadingView.sharedInstance.show()
        
        let group = DispatchGroup()
        
        if let movieId = movie?.id {
            
            group.enter()
            NetworkingService.sharedInstance.getMovieDetails(movieId: movieId) { [weak self] result in
                
                switch result {
                case .success(let movieDetails):
                    print("Terminou de carregar task 1")
                    DispatchQueue.main.async {
                        self?.movieTagline.text = movieDetails.tagline ?? ""
                        self?.movieRating.text = "\(movieDetails.voteAverage ?? 0.0)℅".replacingOccurrences(of: ".", with: "")
                        
                        //self.castArray = movieDetails
                        self?.castCollectionView.reloadData()
                    }
                    
                    LoadingView.sharedInstance.hide()
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
            group.enter()
            NetworkingService.sharedInstance.getMovieCast(movieId: movieId) { [weak self] result in
                
                switch result {
                    
                case .success(let cast):
                    print("Terminou de carregar task 2")
                    DispatchQueue.main.async {
                        self?.castArray = cast.cast
                        self?.castCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
            group.enter()
            NetworkingService.sharedInstance.getMovieTrailer(movieId: movieId) { [weak self] result in
                
                switch result {
                case .success(let trailer):
                    print("Terminou de carregar task 3")
                    
                    DispatchQueue.main.async {
                        
                        guard let videoID = trailer.results?.first?.key else {
                            
                            UIView.animate(withDuration: 0.5) {
                                self?.videoPlayerViewHeightConstraint.constant = 0
                                self?.videoPlayer.alpha = 0
                            }
                            
                            return
                            
                        }
                        
                        self?.videoPlayer.loadVideoID(videoID)
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
            group.notify(queue: .main) {
                print("Terminou de executar todas tasks")
                LoadingView.sharedInstance.hide()
            }
            
        }
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        ///Make a circle for the score View
        favoriteView.layer.cornerRadius = favoriteView.frame.width / 2
        
        if let urlString = self.movie?.backdropPath {
            self.backgroundImage.loadUrlImageFromSDWeb(urlString: urlString, type: .cover, done: { isLoadFinished in
                
                if isLoadFinished {
                    
                    //self?.imgLoadActivityIndicator.stopAnimating()
                    
                }
                
            })
            
        }else {
            self.backgroundImage.image = UIImage(named: "placeholder")
        }
        
        movieName.text = movie?.title ?? "" + " (2018)"
        moviePlot.text = movie?.overview
        //movieGenre.text = setGenres(idArray: movie?.genreIDS ?? [])
        
        setScore(rating: movie?.voteCount ?? 50)
        
    }
    
    private func setScore(rating: Int) {
        
        let center = CGPoint(x: 38.0, y: 38.0)
        let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.8242291808, green: 0.8366972804, blue: 0.1931050718, alpha: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
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

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Collection View methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let nCells = castArray?.count ?? 0
        
        if nCells > 8 {
            return 9
        }
        
        return nCells
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCellID", for: indexPath) as! CastCollectionViewCell
        
        if let castElement = castArray?[indexPath.item] {
            
            cell.setupCell(cast: castElement, item: indexPath.item)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .init(8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width / 3.6, height: castCollectionView.frame.height - 16)
        
    }
    
}

extension DetailsViewController: YouTubePlayerDelegate {
    
    //self?.videoPlayer.play()
    
    func playerReady(videoPlayer: YouTubePlayerView) {
        print("TERMINOU DE CARREGAR VIDEO 1")
    }
    
    func playerStateChanged(videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("TERMINOU DE CARREGAR VIDEO 2")
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("TERMINOU DE CARREGAR VIDEO 3")
    }
    
}
