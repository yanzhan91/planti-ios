//
//  RestaurantMenuViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/25/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMenuViewController: UIViewController {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionsScrollView: OptionsScrollView!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    var restaurantName : String = "Restaurant Name"
    var option : Options = .vegan
    var placeId : String = ""
    var latitude : Double = 180
    var longitude : Double = 180
    
    private var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restaurantNameLabel.text = restaurantName
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.optionsScrollView.delegate = self
        self.optionsScrollView.setPreference(option: self.option)
        
        if (!DeviceType.hasTopNotch) {
            self.navigationBarHeight.constant = 85
        }
        
        didChangeOption(self.option)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigate(_ sender: Any) {
        let name = self.restaurantName.replacingOccurrences(of: " ", with: "+")
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let url = "comgooglemaps://?daddr=\(name)&center=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            let url = "http://maps.apple.com/maps?daddr=\(name)&center=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is PostViewController) {
            let pvc = segue.destination as! PostViewController
            pvc.name = self.restaurantName
            pvc.coordinate = CLLocationCoordinate2D.init(latitude: self.latitude, longitude: self.longitude)
        }
    }
}

extension RestaurantMenuViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntreeCell") as! EntreeCell
        let menuItem = self.menuItems[indexPath.row]
        if (menuItem.imageUrl != nil) {
            cell.entreeImage.imageFromURL(urlString: menuItem.imageUrl!)
        }
        cell.containsLabel.text = menuItem.containsLabel
        cell.name.text = menuItem.name
        cell.posted.text = "02/26/2019 Posted by user"
        cell.dropdownMenuButton.tag = indexPath.row
        cell.dropdownMenuButton.addTarget(self, action: #selector(openDropDown), for: .touchUpInside)
        
        return cell
    }
    
    @objc func openDropDown(sender: UIButton) {
        let menuItem = self.menuItems[sender.tag]
        let optionMenu = UIAlertController(title: self.restaurantName, message: menuItem.name, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction.init(title: "Report Error", style: .destructive) { (action) in
            if (menuItem.id != nil) {
                RestService.shared().reportError(id: menuItem.id!)
            }
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

extension RestaurantMenuViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        RestService.shared().getMenuItems(option: self.option, placeId: placeId) { menuItems in
            print("Changing options \(option)")
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
}
