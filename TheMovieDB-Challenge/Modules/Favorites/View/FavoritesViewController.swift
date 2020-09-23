//
//  FavoritesViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 30/01/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var favoritesSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.controller = MovieController()
        //controller?.loadFavoriteMovies()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.controller?.delegate = self
        
        // self.controller?.loadFavoriteMovies()
        //        self.favoritesTableView.reloadData()
        
    }
    
    private func setUp() {
        
        favoritesSearchBar.searchTextField.backgroundColor = .white
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        
        ///Register Cells
        self.favoritesTableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
    }
    
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0// self.controller?.numberOfRowsForFavorites() ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell : MovieCollectionViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        //cell.setupCell(movie: (self.controller?.loadMovieWithIndexPathForFavorites(indexPath: indexPath))!)
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.performSegue(withIdentifier: "goToDetailsOfFav", sender: self)
        
    }
    
    
}

//MARK: - UISearchBar Delegate methods
extension FavoritesViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //self.controller?.updateFavoriteArray()
                self.favoritesTableView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //self.controller?.updateFavoriteArray()
                self.favoritesTableView.reloadData()
            }
            
        }
        else {
            
            //self.controller?.searchFavoriteByValue(searchText: searchText)
            
            self.favoritesTableView.reloadData()
        }
        
    }
    
}
