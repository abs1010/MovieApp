//
//  SettingsViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 18/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var successLoginObserver: NSObjectProtocol?
    private var loggedOutObserver: NSObjectProtocol?
    
    private var itemsArray = [
        SettingsItems(id: 0, description: "Rate the App"),
        SettingsItems(id: 1, description: "©TMDB API Credits"),
        SettingsItems(id: 2, description: "Log Out")
    ]
    
    //MARK: - Sets the StatusBar as white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUp()
        setupNotificationObserver()
    }
    
    deinit {
        
        if let successLogin = successLoginObserver {
            NotificationCenter.default.removeObserver(successLogin)
        }
        if let loggedOUt = loggedOutObserver {
            NotificationCenter.default.removeObserver(loggedOUt)
        }
        
    }
    
    private func setupNotificationObserver() {
        
        successLoginObserver = NotificationCenter.default.addObserver(forName: .loggedInSuccessfully, object: nil, queue: .main) { [weak self] ( _ ) in
            
            self?.alterArrayState(set: .logged)
            
        }
        
        loggedOutObserver = NotificationCenter.default.addObserver(forName: .loggedOut, object: nil, queue: .main) { [weak self] ( _ ) in
            
            self?.alterArrayState(set: .notLogged)
            
        }
        
    }
    
    private enum state {
        case logged
        case notLogged
    }
    
    private func alterArrayState(set to: state ) {
        switch to {
        case .logged:
            let new = SettingsItems(id: 2, description: "Log Out")
            itemsArray.removeLast()
            itemsArray.append(new)
        case .notLogged:
            let new = SettingsItems(id: 2, description: "Log In")
            itemsArray.removeLast()
            itemsArray.append(new)
            
        }
        
        settingsTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLoginState()
    }
    
    private func checkLoginState() {
        
        let login = LoginStateService.sharedInstance
        
        if login.isUserLogged() {
            self.alterArrayState(set: .logged)
            return
        }else {
            self.alterArrayState(set: .notLogged)
        }
        
    }
    
    private func setUp() {
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func logOutUser() {
        
        let login = LoginStateService.sharedInstance
        
        if login.isUserLogged() {
            login.logOutUser()
        }
        
        settingsTableView.reloadData()
        
    }
    
    private func showDevAlert() {
        
        let alerta = UIAlertController(title: "Alert", message: "Feature to be developed ;)", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "Done 😀", style: .destructive, handler: nil)
        
        alerta.addAction(btnOk)
        
        self.present(alerta, animated: true)
        
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = itemsArray[indexPath.row].description
        
        if indexPath.row == itemsArray.last?.id {
            cell.accessoryType = .none
            
            //if !LoginStateService.sharedInstance.isUserLogged() {
            //    cell.textLabel?.isEnabled = false
            //}
            
        }else if indexPath.row == 1 {
            cell.accessoryType = .detailDisclosureButton
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            showDevAlert()
        case 1:
            performSegue(withIdentifier: "goToCredits", sender: self)
        case 2:
            if LoginStateService.sharedInstance.isUserLogged() {
                
                let alerta = UIAlertController(title: "Alert", message: "You will be logged out. Would you like to continue?", preferredStyle: .alert)
                let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let btnLogout = UIAlertAction(title: "Log Out", style: .default, handler: {_ in
                    self.logOutUser()
                })
                
                alerta.addAction(btnCancel)
                alerta.addAction(btnLogout)
                
                self.present(alerta, animated: true)
            }else {
                let loginView = LoginRouter.createModule(as: .fullScreen)
                self.present(loginView, animated: true)
            }
            
        default:
            print("Outros")
        }
        
    }
    
}

extension SettingsViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        print("Google user was disconnected")
        
        AlertService.shared.showAlert(image: .success, title: "Alert", message: "The user has been disconnected")
        
    }
    
}
