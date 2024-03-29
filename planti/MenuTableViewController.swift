//
//  MenuTableViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 3/2/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import SideMenu

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        self.versionLabel.text = "v\(version ?? "0.0")"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        
        if let presenter = presentingViewController as? RestaurantParentViewController {
            switch indexPath.row {
            case 1:
                let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
                pvc.delegate = presenter.self
                pvc.option = presenter.optionScrollView.getPreference()
                presenter.present(pvc, animated: true, completion: nil)
                break
            case 2:
                let termsVC = UIStoryboard(name: "Main", bundle:nil)
                    .instantiateViewController(withIdentifier: "textVC") as! TextViewController
                termsVC.nameText = "About"
                termsVC.htmlText = Documents.shared().getDocument(name: "Credits", type: "txt")
                presenter.present(termsVC, animated: true, completion: nil)
                break
            case 3:
                let termsVC = UIStoryboard(name: "Main", bundle:nil)
                    .instantiateViewController(withIdentifier: "textVC") as! TextViewController
                termsVC.nameText = "Terms of Use"
                termsVC.textviewText = Documents.shared().getDocument(name: "Terms", type: "txt")
                presenter.present(termsVC, animated: true, completion: nil)
                break
            case 4:
                let privacyVC = UIStoryboard(name: "Main", bundle:nil)
                    .instantiateViewController(withIdentifier: "textVC") as! TextViewController
                privacyVC.nameText = "Privacy Policy"
                privacyVC.textviewText = Documents.shared().getDocument(name: "Privacy", type: "txt")
                presenter.present(privacyVC, animated: true, completion: nil)
                break
//            case 4:
//                let settingsVC = UIStoryboard(name: "Main", bundle:nil)
//                    .instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
//                presenter.present(settingsVC, animated: true, completion: nil)
//                break
            default:
                break;
            }
        }
    }
}
