//
//  HomeViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 08/05/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import FirebaseCrashlytics

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    weak var presenter: HomeViewToPresenterProtocol?
    private var refreshControl: UIRefreshControl?
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingView.sharedInstance.show()
        
        addRefreshingControl()
        
        presenter?.requestFirstCallOfMovies()
        
        setUp()
        
        registerCells()
        
        chechLoginState()
        
    }
    
    private func chechLoginState() {
        
        if !LoginStateService.sharedInstance.isUserLogged() {

            perform(#selector(shouldShowOnboarding), with: self, afterDelay: 2.5)

        }
        
    }
    
    @objc func shouldShowOnboarding() {
        
        let identifier = "OnboardingViewControllerIdentifier"
        
        let homeStoryboard = UIStoryboard.init(name: "Onboarding", bundle: nil)
        
        let onbordingViewController = homeStoryboard.instantiateViewController(withIdentifier: identifier)
        
        self.present(onbordingViewController, animated: true)
        
    }
    
    private func setUp() {
        
        mainCollectionView.showsVerticalScrollIndicator = false
        
        ///Delegate and DataSource methods
        [mainCollectionView].forEach { (collectionView) in
            
            collectionView?.delegate = self
            collectionView?.dataSource = self
            
        }
        
    }
    
    //MARK: - Register Cells
    fileprivate func registerCells() {
        
        let cellID = "MainCollectionViewCellID"
        mainCollectionView.register(CategorySectionsCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        mainCollectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier)
        
    }
    
    private func addRefreshingControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = #colorLiteral(red: 0.5346772075, green: 0.8092244267, blue: 0.6423767805, alpha: 1)
        self.refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        self.mainCollectionView.addSubview(refreshControl ?? UIView())
        
    }
    
    @objc private func refreshList() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.refreshControl?.endRefreshing()
            self.presenter?.requestFirstCallOfMovies()
        }
        
    }
    
}

//MARK: - CollectionView Methods Extension
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        ///Main Screen has only one section now // Series will come afterwards
        return presenter?.numberOfSections() ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1 ///One row for each category
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeSectionHeaderView.reuseIdentifier, for: indexPath) as! HomeSectionHeaderView
        
        sectionHeaderView.movieTypeLabel.text = presenter?.getCategoryName(section: indexPath.section)
        
        sectionHeaderView.selectedSection = indexPath.section
        sectionHeaderView.delegate = self
        
        return sectionHeaderView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return .init(width: view.frame.width, height: 30.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let withReuseIdentifier = "MainCollectionViewCellID"
        
        let cell: CategorySectionsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath) as! CategorySectionsCollectionViewCell
        
        if let arrayMovies = presenter?.loadMovieArrayWithIndexPath(indexPath: indexPath) {
            
            cell.categorizedArray = arrayMovies
            
        }
        
        cell.selectedSection = indexPath.section
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 215)//view.frame.height / 4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
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
    
    func problemOnFetchingData(error: errorTypes) {
        
        ///Show Alert with problem
        
    }
    
}

//MARK: - MainCollectionViewCellDelegate Protocol Methods

extension HomeViewController: MainCollectionViewCellDelegate {
    
    func didSelectItemAt(indexPath: IndexPath) {
  
        presenter?.showMovie(indexPath: indexPath)
        
    }
    
    func didTapToSeeDetails(_ section: Int) {
        
        if let selection = presenter?.getSelectionWithSection(section: section) {
            
            let vc = MovieListRouter.createModule(as: .fullScreen, selection: selection)
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}
