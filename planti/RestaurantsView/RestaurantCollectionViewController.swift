//
//  RestaurantCollectionViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/30/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RestaurantCollectionCell"

class RestaurantCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var restaurants: [Restaurant] = []
    private var pvc: RestaurantParentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pvc = self.parent as? RestaurantParentViewController
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.restaurants.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RestaurantCollectionViewCell
        
        let restaurant = self.restaurants[indexPath.row]
        cell.loadImage(url: URL.init(string: restaurant.getImageUrl())!)
        cell.name.text = restaurant.restaurantName
        cell.address.text = restaurant.address
        
        if (restaurant.distance < 0) {
            cell.distance.text = ""
        } else {
            cell.distance.text = "\(restaurant.distance) mi"
        }
        
        cell.ratingsView.setRatings(ratings: restaurant.rating)
        cell.ratingsView.numReviews.text = String(restaurant.numRatings)
        
        cell.latitude = restaurant.latitude
        cell.longitude = restaurant.longitude
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 40;
        let cellSize = collectionView.frame.size.width - padding;
        return CGSize(width: cellSize, height: cellSize / 3 + 78);
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = self.restaurants[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rmvc = storyboard.instantiateViewController(withIdentifier: "restaurantMenuVC") as! MenuItemViewController
        rmvc.option = (self.pvc?.optionScrollView.getPreference())!
        rmvc.restaurantName = restaurant.restaurantName!
        rmvc.chainId = restaurant.chainId
        rmvc.delegate = self.pvc
        self.present(rmvc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 60, right: 0)
    }
    
    public func reload(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        self.collectionView.reloadData()
        if (restaurants.isEmpty) {
            let alert = AlertService.shared().createOkAlert(title: "No restaurant here yet", message: "Help the community by submitting new restaurants", buttonTitle: "Ok", viewController: self)
            self.present(alert, animated: true)
        }
    }
}
