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
import Hero
import YouTubePlayer

final class DetailsViewController: UIViewController {
    
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
    @IBOutlet weak var classificationAndDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var videoPlayerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var crew1Dir: UILabel!
    @IBOutlet weak var crew1Role: UILabel!
    @IBOutlet weak var crew2Dir: UILabel!
    @IBOutlet weak var crew2Role: UILabel!
    @IBOutlet weak var crew3Dir: UILabel!
    @IBOutlet weak var crew3Role: UILabel!
    @IBOutlet weak var crew4Dir: UILabel!
    @IBOutlet weak var crew4Role: UILabel!
    @IBOutlet weak var crew5Dir: UILabel!
    @IBOutlet weak var crew5Role: UILabel!
    @IBOutlet weak var crew6Dir: UILabel!
    @IBOutlet weak var crew6Role: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    
    let realm = try! Realm()
    var castArray: [CastElement]?
    let shapeLayer = CAShapeLayer()
    var movie : Movie? {
        
        didSet {
            view.hero.id = "\(movie?.id ?? 0)"
            backgroundImage.hero.modifiers = [.arc(), .scale(1.5)]
        }
        
    }
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollection()
        setupCell()
        
    }
    
    @IBAction func tappedGoBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func didSwipeFromLeft(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func setUpCollection() {
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCellID")
        castCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupCell() {
        
        LoadingView.sharedInstance.show()
        
        ///Pins the view the content area of the scroll view.
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        ///Set Player Delegate
        videoPlayer.delegate = self
        
        ///Adding Swipe gesture
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeFromLeft(_:)))
        view.addGestureRecognizer(gesture)
        
        ///Make a circle for the score View
        favoriteView.layer.cornerRadius = favoriteView.frame.width / 2
        
        let group = DispatchGroup()
        
        if let movieId = movie?.id {
            
            group.enter()
            NetworkingService.sharedInstance.getMovieDetails(movieId: movieId) { [weak self] result in
                
                switch result {
                case .success(let movieDetails):
                    print("Terminou task 1")
                    DispatchQueue.main.async {
                        self?.fillMovieInfo(movieDetails)
                        self?.castCollectionView.reloadData()
                        LoadingView.sharedInstance.hide()
                    }
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
                
            }
            
            group.enter()
            NetworkingService.sharedInstance.getMovieCast(movieId: movieId) { [weak self] result in
                
                switch result {
                
                case .success(let cast):
                    print("Terminou task 2")
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
                    print("Terminou task 3")
                    
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
        
    }
    
    private func setScore(rating: Double) {
        
        let backLayer = CAShapeLayer()
        let center = CGPoint(x: 38.0, y: 38.0)
        let circularPathA = UIBezierPath(arcCenter: center, radius: 30, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        backLayer.path = circularPathA.cgPath
        backLayer.strokeColor = #colorLiteral(red: 0.2550989985, green: 0.2339877486, blue: 0.05938784778, alpha: 1)
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.lineCap = CAShapeLayerLineCap.round
        backLayer.lineWidth = 5
        backLayer.strokeEnd = 1
        
        scoreView.layer.addSublayer(backLayer)
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = (2 * ((CGFloat.pi / 100.0) * CGFloat(rating * 10)) + startAngle)
        let circularPath = UIBezierPath(arcCenter: center, radius: 30, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
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
        basicAnimation.delegate = self
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    func fillMovieInfo(_ movieDetails: MovieDetails) {
        
        ///Background Image
        if let urlString = self.movie?.backdropPath {
            self.backgroundImage.loadUrlImageFromSDWeb(urlString: urlString, type: .cover, done: { _ in
                
            })
        }else {
            self.backgroundImage.image = UIImage(named: "movie-placeholder")
        }
        
        self.moviePlot.text = movie?.overview
        self.setScore(rating: movie?.voteAverage ?? 50.0)
        
        self.movieName.text = "\(movieDetails.title ?? "") (\(movieDetails.releaseDate?.prefix(4) ?? ""))"
        self.movieTagline.text = movieDetails.tagline ?? ""
        self.movieRating.text = "\(movieDetails.voteAverage ?? 0.0)%".replacingOccurrences(of: ".", with: "")
        
        ///Converts the String into date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: movieDetails.releaseDate ?? "")
        ///Converts the date into a fommated String
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        let formattedDate = formatDate.string(from: date ?? Date())
        
        self.classificationAndDate.text = "[12] " + formattedDate
        
        ///Crew
        /*
         crew1Dir.text = movieDetails
         crew1Role
         crew2Dir
         crew2Role
         crew3Dir
         crew3Role
         crew4Dir
         crew4Role
         crew5Dir
         rew5Role
         crew6Dir
         crew6Role
         */
        ///Genres
        if let genres = movieDetails.genres, let duration = movieDetails.runtime {
            
            var genresByName = ""
            
            for i in genres {
                
                genresByName.append(i.name ?? "")
                genresByName.append(", ")
                
            }
            
            let str = genresByName[0..<(genresByName.count - 2)] + " • " + setDurationAsString(duration)
            
            self.movieGenre.text = str
        }
        
        ///Other information
        statusLabel.text = movieDetails.status
        originalLanguageLabel.text = movieDetails.originalLanguage
        budgetLabel.text = convertIntToCurrencyString(value: movieDetails.budget ?? 0)
        revenueLabel.text = convertIntToCurrencyString(value: movieDetails.revenue ?? 0)
        
    }
    
    func convertIntToCurrencyString(value: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyISOCode
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")//pt_BR
        
        return numberFormatter.string(from: NSNumber(value: value)) ?? "0"
        
    }
    
    func setDurationAsString(_ duration: Int) -> String {
        
        var formmatedDuration: String {
            
            if duration < 60 {
                return "\(duration)m"
            }
            else if duration < 120 {
                return "1h \(duration - 60)m"
            }
            else if duration < 180 {
                return "2h \(duration - 120)m"
            }
            else if duration < 240 {
                return "3h \(duration - 180)m"
            }
            else if duration < 300 {
                return "4h \(duration - 240)m"
            }
            else if duration < 360 {
                return "5h \(duration - 300)m"
            }
            else if duration < 420 {
                return "6h \(duration - 360)m"
            }
            else {
                return "0h 0m"
            }
            
        }
        
        return formmatedDuration
        
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

extension DetailsViewController : CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animation did start")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation did finish")
    }
    
}
