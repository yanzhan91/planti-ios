//
//  PreferenceViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleSignIn

class PreferenceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var optionsPopupView: OptionsPopupView!
    var isPreferenceView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
        
        self.optionsPopupView.layer.borderColor = Colors.themeGreen.cgColor
        self.optionsPopupView.layer.borderWidth = 2.0
        
        self.optionsPopupView.setPreference(option: .vegan)
        
        if (isPreferenceView) {
            self.optionsPopupView.changeButton.setTitle("Join", for: .normal)
            self.optionsPopupView.cancelButton.setTitle("Logout", for: .normal)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(join(_:)), name: NSNotification.Name("preferencePopupChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name("preferencePopupCancel"), object: nil)
    }
    
    @objc func join(_ notification: Notification) {
        UserDefaults.standard.set((notification.userInfo?["option"] as! Options).rawValue, forKey: DefaultsKeys.PREFERENCE)
        performSegue(withIdentifier: "SignedIn", sender: self)
    }
    
    @objc func logout() {
        GIDSignIn.sharedInstance()?.disconnect()
        dismiss(animated: true, completion: nil)
    }
    
    private func getScrollViewContentSize(scrollView: UIScrollView) -> CGSize {
        var contentRect = CGRect.zero
        
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        contentRect.size.height += 30
        return contentRect.size
    }
}