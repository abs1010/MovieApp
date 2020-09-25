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
    
    var presenter: FavoritesViewToPresenterProtocol?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Movie>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Movie>
    
    private var dataSource: DataSource!
    private var snapshot: DataSourceSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @objc private func updateListOfFavorites() {
        
        presenter?.getFavoriteMovies()
        
    }
    
    private func setUp() {
        
        favoritesSearchBar.searchTextField.backgroundColor = .white
        self.favoritesCollectionView.delegate = self
        self.favoritesCollectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
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
                self.favoritesCollectionView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.presenter?.resetArray()
                self.favoritesCollectionView.reloadData()
            }
            
        }
        else {
            
            self.presenter?.searchByValue(searchText: searchText)
            self.favoritesCollectionView.reloadData()
            
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
            UIView.animate(withDuration: 0.9, delay: 0.5, options: .transitionCrossDissolve) {
                self.animatedView.isHidden = false
                self.animatedView.alpha = 1
            } completion: { _ in
                self.lottieStartAnimation(on: self.animatedView, animationName: .empty)
            }
            
        }
        
    }
    
    func FailRequestResults() {
        ///Show Alert of Failure
    }
    
}
