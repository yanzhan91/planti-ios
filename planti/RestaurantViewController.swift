//
//  RestaurantViewController.swift
//  planti
//
//  Created by Yan Zhan on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleMaps

class RestaurantViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var optionScrollView: UIScrollView!
    @IBOutlet weak var listView: UITableView!
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 15.0
    private var optionButtonSelected : ThemeButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupMapView()
        setupListView()
        setupOptionScrollView()
        setupSearchBar()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
    }
    
    @IBAction func switchToList(_ sender: Any) {
        
    }
    
    fileprivate func setupSearchBar() {
        let searchButton = UIButton.init(type: .custom)
        searchButton.setImage(UIImage(named: "search_icon"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 21, height: 16)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.searchField.leftView = searchButton
        self.searchField.leftViewMode = .always
        
        let filterButton = UIButton.init(type: .custom)
        filterButton.setImage(UIImage(named: "filter_icon"), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 21, height: 16)
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        self.searchField.rightView = filterButton
        self.searchField.rightViewMode = .always
    }
    
    fileprivate func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: zoomLevel)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true;
        self.mapView.settings.myLocationButton = true;
        self.mapView.settings.zoomGestures = true;
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    fileprivate func setupListView() {
        self.listView.delegate = self
        self.listView.dataSource = self
    }
    
    private func setupOptionScrollView() {
        var leftSpacing = 5
        let topSpacing = 5
        var totalWidth = 5
        for option in Options.allCases {
            let button = ThemeButton.init(frame: CGRect(x: leftSpacing, y: topSpacing, width: 100, height: 40),
                                          title: option.rawValue)
            
            button.addTarget(self, action: #selector(optionPressed), for: .touchUpInside)
            
            self.optionScrollView.addSubview(button)
            leftSpacing += Int(button.frame.width + 5)
            totalWidth += Int(button.frame.width + 5)
        }
        self.optionScrollView.contentSize = CGSize(width: totalWidth, height: 50)
    }
    
    @objc private func optionPressed(sender: ThemeButton) {
        self.optionButtonSelected?.deactivate()
        self.optionButtonSelected = sender
        sender.activate()
    }
}

extension RestaurantViewController : CLLocationManagerDelegate {
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        print(location.coordinate)
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted:
                print("Location access was restricted.")
            case .denied:
                print("User denied access to location.")
                // Display the map using the default location.
            case .notDetermined:
                print("Location status not determined.")
            case .authorizedAlways: fallthrough
            case .authorizedWhenInUse:
                print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension RestaurantViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("IDLE: \(position)")
        print("RADIUS: \(mapView.getRadius())")
        
        for restaurant in Database.getRestaurants() {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            marker.title = restaurant.name
            marker.snippet = "Chicago"
            marker.map = mapView
        }
    }
}

extension RestaurantViewController : UITableViewDelegate {
    
}

extension RestaurantViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as! ListViewCell
        cell.restaurantImage.imageFromURL(urlString: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png")
        cell.restaurantName.text = "Test Restaurant"
        cell.restaurantAddress.text = "500 W. Madison St, Chicago, IL 60601"
        cell.distance.text = "2.1 miles"
        cell.star1.image = UIImage.init(named: "full_star_icon")
        cell.star2.image = UIImage.init(named: "full_star_icon")
        cell.star3.image = UIImage.init(named: "full_star_icon")
        cell.star4.image = UIImage.init(named: "full_star_icon")
        cell.star5.image = UIImage.init(named: "empty_star_icon")
        cell.reviewNumbers.text = "108"
        cell.setAllTextColors()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius) // meters
    }
}

extension UIImageView {
    func imageFromURL(urlString: String) {
        
        self.contentMode = .scaleAspectFit
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        if self.image == nil{
            activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
}

