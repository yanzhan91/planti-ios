//
//  LoginViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/27/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.googleLoginButton.style = .wide
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserDefaults.standard.set("userId", forKey: user.userID)
            UserDefaults.standard.set("fullName", forKey: user.profile.name)
            UserDefaults.standard.set("email", forKey: user.profile.email)
            performSegue(withIdentifier: "signedIn", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserDefaults.standard.removeObject(forKey: "userid")
            UserDefaults.standard.removeObject(forKey: "fullName")
            UserDefaults.standard.removeObject(forKey: "email")
        }
    }
}
