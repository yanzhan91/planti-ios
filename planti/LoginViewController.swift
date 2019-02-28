//
//  LoginViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        self.googleLoginButton.style = .wide
        
        GIDSignIn.sharedInstance().signInSilently()
        
        if (UserDefaults.standard.string(forKey: "userId") != nil) {
            performSegue(withIdentifier: "SignedIn", sender: self)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: NSNotification.Name(rawValue: "Login"), object: nil)
        }
    }
    
    @objc private func login(_ notification: NSNotification) {
        performSegue(withIdentifier: "SignedIn", sender: self)
    }
}
