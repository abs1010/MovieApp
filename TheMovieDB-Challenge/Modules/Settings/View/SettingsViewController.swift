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
        SettingsItems(id: 0, description: "Conta"),
        SettingsItems(id: 1, description: "Avalie o App"),
        SettingsItems(id: 2, description: "Creditos API ©TMDB"),
        SettingsItems(id: 3, description: "Sair")
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
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = itemsArray[indexPath.row].description
        
        if indexPath.row == 3 {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("Contas conectadas")
        case 1:
            print("Avalie o App")
        case 2:
            performSegue(withIdentifier: "goToCredits", sender: self)
        case 3:
            
            guard let signIn = GIDSignIn.sharedInstance() else { return }
            
            if signIn.hasPreviousSignIn() {
                signIn.signOut()
            }else {
                print("usuário não está logado.")
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
        
    }
    
}
