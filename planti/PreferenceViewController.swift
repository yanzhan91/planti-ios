//
//  PreferenceViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var optionsPopupView: OptionsPopupView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
        
        self.optionsPopupView.layer.borderColor = Colors.themeGreen.cgColor
        self.optionsPopupView.layer.borderWidth = 2.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("User Id: \(UserDefaults.standard.string(forKey: "userId"))")
//        if (UserDefaults.standard.string(forKey: "userId") != nil) {
//            //            performSegue(withIdentifier: "SignedIn", sender: self)
//            performSegue(withIdentifier: "ChoosePreference", sender: self)
//        } else {
//            NotificationCenter.default.addObserver(self, selector: #selector(login(_:)), name: NSNotification.Name(rawValue: "Login"), object: nil)
//        }
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
