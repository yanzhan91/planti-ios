//
//  RestaurantMenuViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/25/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit

class MenuItemViewController: UIViewController {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var optionsScrollView: OptionsScrollView!
    
    var restaurantName : String = "Restaurant Name"
    var option : Options = .vegan
    var chainId : String = ""
    var latitude : Double = 180
    var longitude : Double = 180
    
    var delegate: MenuItemViewControllerDelegate?
    
    private var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restaurantNameLabel.text = restaurantName
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.optionsScrollView.delegate = self
        self.optionsScrollView.setPreference(option: self.option)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.delegate?.optionDidChange(option: self.optionsScrollView.getPreference())
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

extension MenuItemViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let miVC = storyboard.instantiateViewController(withIdentifier: "MenuImageVC") as! MenuImageViewController
        miVC.menuItems = self.menuItems
        miVC.index = indexPath.row
        self.present(miVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCollectionViewCell
        let menuItem = self.menuItems[indexPath.row]
        if (menuItem.imageUrl != nil) {
            cell.loadImage(url: URL(string: menuItem.imageUrl!)!)
        } else {
            cell.image.image = UIImage(named: "default_menu_item_cell_image")
        }
        cell.name.text = menuItem.menuItemName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 30;
        let cellSize = collectionView.frame.size.width - padding;
        return CGSize(width: cellSize / 2, height: cellSize / 2 + 50);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @objc func openDropDown(sender: UIButton) {
        let menuItem = self.menuItems[sender.tag]
        let optionMenu = UIAlertController(title: self.restaurantName, message: menuItem.menuItemName, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "Report Error", style: .default) { (action) in
            if (menuItem.id != nil) {
                RestService.shared().reportError(menuItemId: menuItem.id!, chainId: self.chainId)
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
}

protocol MenuItemViewControllerDelegate {
    func optionDidChange(option: Options)
}

extension MenuItemViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        RestService.shared().getMenuItems(option: option, chainId: chainId) { menuItems in
            self.menuItems = menuItems
            self.collectionView.reloadData()
        }
    }
}
