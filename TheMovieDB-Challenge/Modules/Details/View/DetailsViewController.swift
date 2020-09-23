//
//  DetailsViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 28/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import SDWebImage
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
    
    var presenter: DetailsViewToPresenterProtocol?
    var castArray: [CastElement]?
    let shapeLayer = CAShapeLayer()
    var movie : Movie?
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHero()
        setUp()
        requestMovieInfo()
        
    }
    
    @IBAction func tappedGoBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func DidTapToSaveAsFavorite(_ sender: Any) {
        
        if let movie = self.movie, let id = movie.id {
            
            presenter?.isFavorite(id, completion: { isFavorite in
                
                if isFavorite {
                    
                    self.presenter?.removeFromFavorites(id, completion: { _ in
                        
                    })
                } else {
                    self.presenter?.saveAsFavorite(movie: movie)
                }
                
                let imgName = !isFavorite ? "iconStarFilled" : "iconStar"
                self.btnFavorite.setImage(UIImage(named: imgName), for: .normal)
                
            })
            
        }
        
    }
    
    @objc func didSwipeFromLeft(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func configureHero() {
        
        view.hero.id = "\(movie?.id ?? 0)"
        backgroundImage.hero.modifiers = [.arc(), .scale(1.5)]
        
    }
    
    private func setUp() {
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: "CastCollectionViewCellID")
        castCollectionView.showsHorizontalScrollIndicator = false
        
        ///Pins the view the content area of the scroll view.
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        ///Set Player Delegate
        //videoPlayer.delegate = self
        
        ///Adding Swipe gesture
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeFromLeft(_:)))
        view.addGestureRecognizer(gesture)
        
        ///Make a circle for the score View
        favoriteView.layer.cornerRadius = favoriteView.frame.width / 2
        if let movieID = movie?.id {
            presenter?.isFavorite(movieID, completion: { favourite in
            
                let imgName = favourite ? "iconStarFilled" : "iconStar"
                self.btnFavorite.setImage(UIImage(named: imgName), for: .normal)
                
            })
        }
        
    }
    
    private func requestMovieInfo() {
        
        guard let movieId = movie?.id else { return }
        
        LoadingView.sharedInstance.show()
        
        presenter?.getMovieInfo(for: movieId)
        
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
        //basicAnimation.delegate = self
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        
    }
    
    func fillMovieInfo(_ movieDetails: MovieDetails) {
        
        ///Background Image
        if let urlString = self.movie?.backdropPath {
            UIView.transition(with: backgroundImage, duration: 0.3, options: .transitionCrossDissolve) {
                self.backgroundImage.loadUrlImageFromSDWeb(urlString: urlString, type: .cover, done: { _ in})
            } completion: { _ in}
        }else {
            self.backgroundImage.image = UIImage(named: "movie-placeholder")
        }
        
        moviePlot.text = movie?.overview
        setScore(rating: movie?.voteAverage ?? 50.0)
        movieName.text = "\(movieDetails.title ?? "") (\(movieDetails.releaseDate?.prefix(4) ?? ""))"
        movieTagline.text = movieDetails.tagline ?? ""
        movieRating.text = "\(movieDetails.voteAverage ?? 0.0)%".replacingOccurrences(of: ".", with: "")
        classificationAndDate.text = "[12] " + formatDateAsString(dateString: movieDetails.releaseDate ?? "")
        ///Other info
        statusLabel.text = movieDetails.status
        originalLanguageLabel.text = movieDetails.originalLanguage
        budgetLabel.text = convertIntToCurrencyString(value: movieDetails.budget ?? 0)
        revenueLabel.text = convertIntToCurrencyString(value: movieDetails.revenue ?? 0)

        ///Genres
        if let genres = movieDetails.genres, let duration = movieDetails.runtime {
            let str = generateStringOfGenres(genres: genres) + " • " + setDurationAsString(duration)
            self.movieGenre.text = str
        }
        
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
    }
    
    func generateStringOfGenres(genres: [Genre]) -> String {
        
        var genresByName = ""
        
        for i in genres {
            genresByName.append(i.name ?? "")
            genresByName.append(", ")
        }
        
        let str = genresByName[0..<(genresByName.count - 2)]
        return str
        
    }
    
    func formatDateAsString(dateString: String) -> String {
        
        ///Converts the String into date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        ///Converts the date into a fommated String
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd/MM/yyyy"
        let formattedDate = formatDate.string(from: date ?? Date())
        
        return formattedDate
        
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

//MARK: - return of requests
extension DetailsViewController: DetailsPresenterToViewProtocol {
    
    func showRequestResults(movieDetails: MovieDetails, cast: [CastElement], videoID: String) {
        
        DispatchQueue.main.async {
            LoadingView.sharedInstance.hide()
            self.fillMovieInfo(movieDetails)
            self.castArray = cast
            self.videoPlayer.loadVideoID(videoID)
            self.castCollectionView.reloadData()
            
            //UIView.animate(withDuration: 0.5) {
            //    self?.videoPlayerViewHeightConstraint.constant = 0
            //    self?.videoPlayer.alpha = 0
            //}
        }
        
    }
    
}
