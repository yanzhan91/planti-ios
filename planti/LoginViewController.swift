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
        
        print(UserDefaults.standard.string(forKey: DefaultsKeys.USER_ID))
        
        if (UserDefaults.standard.string(forKey: DefaultsKeys.USER_ID) != nil) {
            performSegue(withIdentifier: "SignedIn", sender: self)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: NSNotification.Name(rawValue: "Login"), object: nil)
        }
    }
    
    @objc private func login(_ notification: NSNotification) {
        performSegue(withIdentifier: "ChoosePreference", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is PreferenceViewController) {
            let vc = segue.destination as! PreferenceViewController
            vc.isPreferenceView = true
        } else if (segue.destination is RestaurantViewController) {
            
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
}
