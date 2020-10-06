//
//  FavoritesViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 30/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import Hero
import Lottie

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var favoritesSearchBar: UISearchBar!
    @IBOutlet weak var animatedView: AnimationView!
    private var refreshControl: UIRefreshControl?
    var presenter: FavoritesViewToPresenterProtocol?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Movie>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Movie>
    
    private var dataSource: DataSource!
    private var snapshot: DataSourceSnapshot!
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshingControl()
        setUp()
        configureCollectionViewDataSource()
        updateListOfFavorites()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        perform(#selector(updateListOfFavorites), with: self, afterDelay: 0.4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        lottieStopAnimation(on: animatedView)
        animatedView.isHidden = true
        favoritesSearchBar.text?.removeAll()
    }
    
    @objc private func updateListOfFavorites() {
        
        presenter?.getFavoriteMovies()
        
    }
    
    private func addRefreshingControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.5346772075, green: 0.8092244267, blue: 0.6423767805, alpha: 1)
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.favoritesCollectionView.addSubview(refreshControl ?? UIView())
        
    }
    
    @objc private func refreshList() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.refreshControl?.endRefreshing()
            self.presenter?.getFavoriteMovies()
        }
        
    }
    
    private func setUp() {
        
        favoritesSearchBar.searchTextField.backgroundColor = .white
        self.favoritesCollectionView.delegate = self
        self.favoritesCollectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        ///Sets a tap gesture on view in order to dismiss keyboard
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        favoritesCollectionView.addGestureRecognizer(tap)
        
    }
    
    private func configureCollectionViewDataSource() {
        
        dataSource = DataSource(collectionView: favoritesCollectionView, cellProvider: { (collectionView, indexPath, movie) -> MovieCollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            
            if let movie = self.presenter?.loadMovieWithIndexPath(indexPath: indexPath) {
                
                cell.hero.id = "\(movie.id ?? 0)"
                Hero.shared.apply(modifiers: [.fade, .scale(2.5), .cascade], to: cell)
                
                cell.setupCell(movie: movie)
                
            }
            
            return cell
            
        })
        
    }
    
}

extension FavoritesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width / 3.4 , height: 190)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 10, bottom: 20.0, right: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter?.showMovie(row: indexPath.row)
        
    }
    
}

//MARK: - UISearchBar Delegate methods
extension FavoritesViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.presenter?.resetArray()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.presenter?.resetArray()
                self.lottieStopAnimation(on: self.animatedView)
                self.animatedView.isHidden = true
            }
            
        }
        else {
            
            lottieStopAnimation(on: animatedView)
            animatedView.isHidden = true
            
            self.presenter?.searchByValue(searchText: searchText)
            
        }
        
    }
    
}

extension FavoritesViewController: FavoritesPresenterToViewProtocol {
    
    func showRequestResults(_ movies: [Movie]) {
        
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        //snapshot.appendItems(movies, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if movies.count == 0 {
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .transitionFlipFromBottom, animations: {
                self.animatedView.isHidden = false
                self.animatedView.alpha = 1
            }) { _ in
                self.lottieStartAnimation(on: self.animatedView, animationName: .empty)
            }
            
        }
        
    }
    
    func FailRequestResults() {
        ///Show Alert of Failure
        AlertService.shared.showAlert(image: .failure, title: "Sorry...", message: "There was an error during the request")
    }
    
}
