//
//  SettingsViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/30/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var newMenuItems: UISwitch!
    @IBOutlet weak var newPromotions: UISwitch!
    @IBOutlet weak var saveButton: ThemeButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.activate()

        RestService.shared().getSettings() { settings in
            self.newMenuItems.setOn(settings.newMenuItems, animated: true)
            self.newPromotions.setOn(settings.newPromotions, animated: true)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let newMenuItems = self.newMenuItems.isOn
        let newPromotions = self.newPromotions.isOn
        
        RestService.shared().postUser(option: nil, settings: Settings.init(newMenuItems: newMenuItems, newPromotions: newPromotions)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
