//
//  HomeViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 08/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var controller : MovieController?
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBarHight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        movieSearchBar.searchTextField.backgroundColor = .white
        self.addRefreshingControl()
        
        //Delegate and protocols
        controller = MovieController()
        controller?.delegate = self
        controller?.loadMovies()
        
        //CV DELEGATE AND DATASOURCE
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        //REGISTER CELL
        let nibName = "MovieCollectionViewCell"
        let identifier = "MovieCell"
        movieCollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetails" {
            
            //            if let vc: DetailsViewController = segue.destination as? DetailsViewController {
            //
            //                if let indexPath = movieCollectionView.indexPathsForSelectedItems {
            //                    vc.movie = self.controller?.loadMovieWithIndexPath(indexPath: indexPath[0], favorite: false)
            //                }
            //
            //            }
            
        }
        
    }
    
    func addRefreshingControl(){
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.01317793038, green: 0.1344225705, blue: 0.2308762968, alpha: 1)
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.movieCollectionView.addSubview(refreshControl!)
        
    }
    
    @objc func refreshList() {
        
        self.refreshControl?.endRefreshing()
        self.controller?.loadMovies()
        self.movieCollectionView.reloadData()
        
    }
    
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.controller?.numberOfRows() ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.setupCell(movie: (self.controller?.loadMovieWithIndexPath(indexPath: indexPath, favorite: false))!)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: view.frame.width / 2.2 , height: view.frame.height / 2.3)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 10, bottom: 20.0, right: 10)
        //return .init(top: 0, left: 12, bottom: 0, right: 12)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
        DispatchQueue.main.async {
            
            if offset > magicalSafeAreaTop {
                UIView.animate(withDuration: 1.5) {
                    self.searchBarHight.constant = 0
                    //self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
                    
                    self.movieSearchBar.transform = .init(translationX: 0, y: min(0, -offset))
                    
                }
                
            }else{
                
                UIView.animate(withDuration: 0.5) {
                    self.searchBarHight.constant = 44.00
                    //self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, offset))
                    self.movieSearchBar.transform = .init(translationX: 0, y: min(0, offset))
                    
                }
                
            }
            
        }
        
        //let alpha = 1 - (offset / safeAreaTop)
        
        //[movieSearchBar, navigationController?.navigationBar].forEach{$0?.alpha = alpha}
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.performSegue(withIdentifier: "goToDetails", sender: self)
        
    }
    
}

//MARK: - UISearchBar Delegate methods

extension HomeViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.controller?.updateArray()
                self.movieCollectionView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.controller?.updateArray()
                self.movieCollectionView.reloadData()
            }
            
        }
        else {
            
            self.controller?.searchByValue(searchText: searchText)
            
            self.movieCollectionView.reloadData()
        }
        
    }
    
}

extension HomeViewController : MovieControllerDelegate {
    
    func successOnLoading() {
        
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
        
    }
    
    func errorOnLoading(error: Error?) {
        
        if !error!.localizedDescription.isEmpty {
            
            DispatchQueue.main.async {
                
                print("Problema ao carregar os dados de Filmes")
                
                let alerta = UIAlertController(title: "Erro", message: "Problema ao carregar os dados dos Filmes", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
                
                alerta.addAction(btnOk)
                
                self.present(alerta, animated: true)
                
            }
            
        }
        
    }
    
}

