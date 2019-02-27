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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restaurantNameLabel.text = restaurantName
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RestaurantMenuViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntreeCell") as! EntreeCell
        cell.entreeImage.imageFromURL(urlString: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png")
        cell.containsLabel.text = "Contains: egg, fish"
        cell.name.text = "Chicken Pot Pie"
        cell.posted.text = "02/26/2019 Johnnyvilleville S"
        cell.dropdownMenuButton.tag = indexPath.row
        cell.dropdownMenuButton.addTarget(self, action: #selector(openDropDown), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDropDown(sender: UIButton) {
        let title = "Chicken Pot Pie"
        
        let optionMenu = UIAlertController(title: self.restaurantName, message: title, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction.init(title: "Report Error", style: .destructive) { (action) in
            // Report Error
            let okAlert = UIAlertController(title: "Thank you for your feedback!", message: nil, preferredStyle: .alert)
            okAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(okAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
