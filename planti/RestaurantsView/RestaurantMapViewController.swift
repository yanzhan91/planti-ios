//
//  RestaurantMapViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleMaps

class RestaurantMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var restaurants: [Restaurant] = []
    
    private var pvc: RestaurantParentViewController?
    private var refreshable = true
    
    private var noRestaurantNotice: ThemeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pvc = self.parent as? RestaurantParentViewController
        
        let location = DefaultsKeys.getEncodedUserDefaults(key: DefaultsKeys.LAST_KNOWN_LOCATION, defaultValue: Location.init(latitude: 41.8823, longitude: -87.6404))
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = false
        self.mapView.settings.myLocationButton = false
        self.mapView.settings.zoomGestures = true
        self.mapView.settings.tiltGestures = false
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.indoorPicker = false
        
        self.refreshButton.isHidden = true
    }
    
    public func getRadius() -> Int {
        return self.mapView.getRadius()
    }
    
    public func getCoordinate() -> CLLocationCoordinate2D {
        return self.mapView.camera.target
    }
    
    public func moveMap(coordinate: CLLocationCoordinate2D) {
        self.refreshable = false
        self.mapView.animate(toLocation: coordinate)
    }

    public func reload(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        self.refreshButton.isHidden = true
        if (restaurants.count == 0) {
            if (self.noRestaurantNotice == nil) {
                let x = self.view.frame.width / 2 - 133
                self.noRestaurantNotice = ThemeButton.init(frame: CGRect.init(x: x, y: 10, width: 266, height: 40), title: "No restaurants yet in this area")
                self.noRestaurantNotice!.activate()
                self.view.addSubview(self.noRestaurantNotice!)
            }
            self.noRestaurantNotice?.isHidden = false
        } else {
            self.noRestaurantNotice?.isHidden = true
            self.mapView.getMarkersAndDisplay(restaurants: restaurants)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.refreshButton.isHidden = true
        self.pvc?.fetchRestaurants(coordinates: self.mapView.camera.target, radius: self.mapView.getRadius())
    }
    
    @IBAction func goToMyLocation(_ sender: Any) {
        self.refreshable = false
        self.refreshButton.isHidden = true
        self.pvc?.updateMyLocation()
    }
}

extension RestaurantMapViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let restaurant = self.restaurants[(marker.userData as? Int)!]
        let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        infoWindow.backgroundColor = .clear
        infoWindow.restaurantName.text = restaurant.name
        infoWindow.setNumReviews(numReviews: String(restaurant.numRatings))
        infoWindow.setRatings(ratings: restaurant.rating)
        //        if (restaurant.imageUrl != nil) {
        //            infoWindow.image.imageFromURL(urlString: restaurant.imageUrl!)
        //        }
        infoWindow.image.image = UIImage.init(named: "default_image")
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let restaurant = self.restaurants[(marker.userData as? Int)!]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rmvc = storyboard.instantiateViewController(withIdentifier: "restaurantMenuVC") as! RestaurantMenuViewController
        rmvc.restaurantName = restaurant.name!
        rmvc.placeId = restaurant.placeId!
        self.present(rmvc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.noRestaurantNotice?.isHidden = true
        if (self.refreshable) {
            self.refreshButton.isHidden = false
        } else {
            self.refreshable = true
            self.refreshButton.isHidden = true
        }
    }
}

extension GMSMapView {

    func getTopRightCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topRightCoor = self.convert(CGPoint(x: self.frame.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topRightCoor)
        return point
    }
    
    func getRadius() -> Int {
        let centerCoordinate = self.camera.target
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopRightCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return Int(round(radius))
    }
    
    func getMarkersAndDisplay(restaurants: [Restaurant]) {
        self.clear()
        for (index, restaurant) in restaurants.enumerated() {
            let marker = GMSMarker()
            marker.userData = index
            marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            marker.map = self
        }
    }
}
