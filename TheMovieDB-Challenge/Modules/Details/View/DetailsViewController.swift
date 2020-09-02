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

class DetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    var genreIDS : Results<Item>?
    
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()
    
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
    
    var castArray: [CastElement]?
    
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
        
        setupCell()
        setUpCollection()
        
    }
    
    private func setUpCollection() {
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCellID")
        castCollectionView.showsHorizontalScrollIndicator = false
    }
    
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
    
    //MARK: - General Methods
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
            
            group.notify(queue: .main) {
                print("Terminou de carregar TUDO")
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
