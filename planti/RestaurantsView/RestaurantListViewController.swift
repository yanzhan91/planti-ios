//
//  RestaurantListViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class RestaurantListViewController: UITableViewController {
    
    private var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = self.restaurants[indexPath.row]
        performSegue(withIdentifier: "openRestaurantMenu", sender: ["restaurantName": restaurant.name, "placeId": restaurant.placeId])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListViewCell
        
        let restaurant = self.restaurants[indexPath.row]
        
        //        if (restaurant.imageUrl != nil) {
        //            cell.restaurantImage.imageFromURL(urlString: restaurant.imageUrl!)
        //        }
        cell.restaurantImage?.image = UIImage.init(named: "default_image")
        cell.restaurantName.text = restaurant.name
        cell.restaurantAddress.text = restaurant.address
        
        if (restaurant.distance < 0) {
            cell.distance.text = ""
        } else {
            cell.distance.text = "8.4 Miles"
        }
        
        cell.ratingsView.setRatings(ratings: restaurant.rating)
        cell.ratingsView.numReviews.text = String(restaurant.numRatings)
        
        cell.latitude = restaurant.latitude
        cell.longitude = restaurant.longitude
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
    
    public func reload(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        self.tableView.reloadData()
    }
}
