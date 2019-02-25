//
//  RestaurantMenuViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/25/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class RestaurantMenuViewController: UIViewController {
    
    var restaurantName : String = "Restaurant Name"
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restaurantNameLabel.text = restaurantName

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
