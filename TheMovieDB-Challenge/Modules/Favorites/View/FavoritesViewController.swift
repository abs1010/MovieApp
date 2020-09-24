//
//  FavoritesViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 30/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import Hero

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBOutlet weak var favoritesSearchBar: UISearchBar!
    
    var presenter: FavoritesViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUp()
        updateListOfFavorites()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateListOfFavorites()
    }
    
    private func updateListOfFavorites() {
        
        presenter?.getFavoriteMovies()
        
    }
    
    private func setUp() {
        
        favoritesSearchBar.searchTextField.backgroundColor = .white
        
        self.favoritesCollectionView.delegate = self
        self.favoritesCollectionView.dataSource = self
        
        ///Register Cells
        self.favoritesCollectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
    }
    
}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        if let movie = presenter?.loadMovieWithIndexPath(indexPath: indexPath) {
            
            cell.hero.id = "\(movie.id ?? 0)"
            //Hero.shared.apply(modifiers: [.fade, .scale(1.5)], to: cell)
            
            cell.setupCell(movie: movie)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width / 3.4 , height: 190)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 10, bottom: 20.0, right: 10)
        
    }
    
}

//MARK: - UISearchBar Delegate methods
extension FavoritesViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //self.controller?.updateFavoriteArray()
                self.favoritesCollectionView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //self.controller?.updateFavoriteArray()
                self.favoritesCollectionView.reloadData()
            }
            
        }
        else {
            
            //self.controller?.searchFavoriteByValue(searchText: searchText)
            
            self.favoritesCollectionView.reloadData()
        }
        
    }
    
}

extension FavoritesViewController: FavoritesPresenterToViewProtocol {
    
    func showRequestResults() {
        ///Show Sucess
        
        favoritesCollectionView.reloadData()
        
    }
    
    func FailRequestResults() {
        ///Show Alert of Failure
    }
    
}
