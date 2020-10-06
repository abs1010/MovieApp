//
//  SettingsViewController.swift
//  TheMovieDB-Challenge
//
//  Created by Alan Silva on 18/06/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private let itemsArray = [
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
        
    }
    
    private func setUp() {
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func checkLoginState() {
        
        if LoginStateService.sharedInstance.isUserLogged() {

            guard let signIn = GIDSignIn.sharedInstance() else { return}
            signIn.signOut()
            
            AlertService.shared.showAlert(image: UIImage(named: "Error")!, title: "Alert", message: "You have been logged out")
            
        }
        
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
            
            if !LoginStateService.sharedInstance.isUserLogged() {
                cell.textLabel?.isEnabled = false
            }
            
        }else if indexPath.row == 1 {
            cell.accessoryType = .detailDisclosureButton
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("Avalie o App")
        case 1:
            performSegue(withIdentifier: "goToCredits", sender: self)
        case 2:
            checkLoginState()
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
        
    }
    
}
