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
    private var isInitialLoad = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        self.googleLoginButton.style = .wide
            NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: NSNotification.Name(rawValue: "Login"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: DefaultsKeys.USER_ID) != nil && self.isInitialLoad) {
            performSegue(withIdentifier: "SignedIn", sender: self)
        } else {
            self.isInitialLoad = false;
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
