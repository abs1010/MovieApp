//
//  HomeViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 08/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import FirebaseCrashlytics
import GoogleSignIn

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    weak var presenter: HomeViewToPresenterProtocol?
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeRouter.initModule(from: self)
        
        LoadingView.sharedInstance.show()
        
        addRefreshingControl()
        
        let movieSelection = Constants.MovieSelection.Popular
        
        ///Delegate and protocols
        presenter?.getMovies(page: 1, category: .Movie, movieSelection: movieSelection)
        
        ///Delegate and DataSource methods
        [mainCollectionView].forEach { $0.delegate = self }
        [mainCollectionView].forEach { $0.dataSource = self }
        
        ///Registereing Cells
        registerCells()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        guard let signIn = GIDSignIn.sharedInstance() else { return }
        
        if !signIn.hasPreviousSignIn() {
            
            perform(#selector(shouldShowOnboarding), with: self, afterDelay: 1)
        }
        
    }
    
    @objc func shouldShowOnboarding() {
        
        let identifier = "OnboardingViewControllerIdentifier"
    
        let homeStoryboard = UIStoryboard.init(name: "Onboarding", bundle: nil)
        
        let onbordingViewController = homeStoryboard.instantiateViewController(withIdentifier: identifier)
        
        self.present(onbordingViewController, animated: true)

    }
    
    //MARK: - Register Cells
    fileprivate func registerCells() {
        
        let cellID = "MainCollectionViewCellID"
        mainCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    //MARK: - TapGestures
    @IBAction func tapToSeeMorePopularMovies(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "Movies", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "MoviesList") as! MovieViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
   private func addRefreshingControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .lightGreen
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.mainCollectionView.addSubview(refreshControl ?? UIView())
        
    }
    
    @objc private func refreshList() {
        
        refreshControl?.endRefreshing()
        
        //controller?.loadMovies(from: true, page: 1, category: .Movie, movieSelection: .Popular)
        [mainCollectionView].forEach { $0?.reloadData() }
        
    }
    
}

//MARK: - CollectionView Methods Extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return presenter?.numberOfSections() ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCellID", for: indexPath) as! MainCollectionViewCell
        
        cell.categoriredArray.append(presenter?.loadMovieWithIndexPath(indexPath: indexPath, movieSelection: Constants.MovieSelection.Popular, favorite: false) ?? Movie())
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 200.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 40.0, left: 10, bottom: 20.0, right: 10)
        
    }
    
}

//MARK: - Controller Protocol Methods

extension HomeViewController: HomePresenterToViewProtocol {
    
    func showMovieResults() {
        
        DispatchQueue.main.async {
            LoadingView.sharedInstance.hide()
            self.mainCollectionView.reloadData()
        }
        
    }
    
    func problemOnFetchingData(error: Constants.errorTypes) {
        
        ///Show Alert with problem
        
    }
    
}
