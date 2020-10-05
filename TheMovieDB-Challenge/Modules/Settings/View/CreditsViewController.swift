//
//  CreditsViewController.swift
//  theMovieAPP
//
//  Created by Alan Silva on 30/09/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import UIKit
import WebKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URLRequest(url: URL(string: "https://www.themoviedb.org/documentation/api")!)
        webView.load(url)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
