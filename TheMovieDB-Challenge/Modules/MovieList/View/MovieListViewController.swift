//
//  HomeViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 08/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import Hero

class MovieListViewController: UIViewController {
    
    var page = 1
    var presenter: MovieListViewToPresenterProtocol?
    var isFethingNewPage = false
    var movieSelection: Constants.MovieSelection?
    var identifierObject: IdentifierObject?
    var noticeNoMoreData = false ///Indicates whether the page limit has reached the end
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBarHight: NSLayoutConstraint!
    @IBOutlet weak var loadingMoreActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    fileprivate func setupView() {
        
        //movieSelection = .Popular
        presenter?.getMovies(category: .Movie, movieSelection: movieSelection!)
        
        movieSearchBar.searchTextField.textColor = UIColor.white
        
        ///Delegate and Datasource
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieSearchBar.delegate = self
        
        ///Registering Cells
        let nibName = "MovieCollectionViewCell"
        let identifier = "MovieCell"
        movieCollectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: identifier)
        
    }
    
    private func showAlertOfLimit() {
        
        DispatchQueue.main.async {
            
            let alerta = UIAlertController(title: "Alert", message: "You have reached the limit ;)", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            
            alerta.addAction(btnOk)
            
            self.present(alerta, animated: true)
            
        }
        
    }
    
    //MARK: - GoBack
    @IBAction func tappedToGoBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Fetch More Pages
    private func startFetchingNewPage() {
        
        if isFethingNewPage {
            print("Another request is already under way")
        }else {
            
            isFethingNewPage = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.loadingMoreActivityIndicator.startAnimating()
                
                guard let select = self.movieSelection else { return }
                
                self.presenter?.getMovies(category: .Movie, movieSelection: select)
                self.isFethingNewPage = false
                
            })
            
        }
        
    }
    
    private func setHideOrShowOnSearchBar(_ scrollView : UIScrollView) {
        
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
        DispatchQueue.main.async {
            
            if offset > 44 {
                
                UIScrollView.animate(withDuration: 0.5) {
                    self.searchBarHight.constant = 0
                    self.movieSearchBar.transform = .init(translationX: 0, y: min(0, -offset))
                }
                
            }else {
                
                UIScrollView.animate(withDuration: 0.5) {
                    self.searchBarHight.constant = 44.00
                    self.movieSearchBar.transform = .init(translationX: 0, y: min(0, offset))
                }
                
            }
            
        }
        
    }
    
}

extension MovieListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter?.getNumberOfRowsInSection(section: identifierObject?.section ?? 0) ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "MovieCell"
        
        let cell : MovieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MovieCollectionViewCell
        
        let index = IndexPath(row: indexPath.row, section: identifierObject?.section ?? 0)
        
        if let movie = presenter?.loadMovieWithIndexPath(indexPath: index) {
            
            cell.hero.id = "\(movie.id ?? 0)"
            Hero.shared.apply(modifiers: [.fade, .scale(1.5)], to: cell)
            
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.setHideOrShowOnSearchBar(scrollView)
        
        guard scrollView.isDragging else {return}
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollFrameHeight = scrollView.frame.height
        
        if offsetY > (contentHeight - scrollFrameHeight) { //1.5
            
            if !isFethingNewPage {
                startFetchingNewPage()
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Details", bundle: nil)
        let identifier = "DetailsViewControllerID"
        
        let vc: DetailsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! DetailsViewController
        
        let index = IndexPath(row: indexPath.row, section: identifierObject?.section ?? 0)
        
        vc.movie = presenter?.loadMovieWithIndexPath(indexPath: index)
        
        present(vc, animated: true, completion: nil)
        
    }
    
}

//MARK: - UISearchBar Delegate methods

extension MovieListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.presenter?.resetArray()
                self.movieCollectionView.reloadData()
            }
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.presenter?.resetArray()
                self.movieCollectionView.reloadData()
            }
            
        }
        else {
            
            self.presenter?.searchByValue(searchText: searchText)
            self.movieCollectionView.reloadData()
        }
        
    }
    
}

extension MovieListViewController: MovieListPresenterToViewProtocol {
    
    func showMovieResults() {
        
        DispatchQueue.main.async {
            
            if self.page > 1 {
                
                var indices = [IndexPath]()
                let initial = ((self.page - 1) * 20)
                let final = ((self.page) * 20) - 1
                let seq = [Int](initial...final)

                for (_, index ) in seq.enumerated() {
                    indices.append(IndexPath(item: index, section: 0))
                }
                #warning("Refactor")
                //self.movieCollectionView.reloadData()
                self.movieCollectionView.insertItems(at: indices)
                indices.removeAll()
            }else {
                self.movieCollectionView.reloadData()
            }
            
            self.page += 1
            self.loadingMoreActivityIndicator.stopAnimating()

        }
        
    }
    
    func problemOnFetchingData(error: errorTypes) {
        
        DispatchQueue.main.async {
            
            let alerta = UIAlertController(title: "Erro", message: "Problema ao carregar os dados dos Filmes", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alerta.addAction(btnOk)
            
            self.present(alerta, animated: true)
            
        }
        
    }
    
    func limitOfPagesReached() {
        
        guard noticeNoMoreData == false else { return }
        
        noticeNoMoreData = true
        
        self.loadingMoreActivityIndicator.stopAnimating()
        
        showAlertOfLimit()
        
    }
    
}
