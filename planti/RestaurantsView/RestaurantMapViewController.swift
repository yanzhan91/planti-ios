//
//  RestaurantMapViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit
//import GoogleMaps

class RestaurantMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var restaurants: [Restaurant] = []
    
    private var pvc: RestaurantParentViewController?
    private var refreshable = true
    
    private var noRestaurantNotice: ThemeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pvc = self.parent as? RestaurantParentViewController
        
        self.mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: 41.8823, longitude: -87.6404)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    
        self.mapView.delegate = self
        self.mapView.isRotateEnabled = false
        self.mapView.showsUserLocation = true
        self.mapView.isPitchEnabled = false
        self.mapView.showsBuildings = false
        self.mapView.showsTraffic = false
        self.mapView.showsPointsOfInterest = false
        
        self.refreshButton.isHidden = true
    }
    
    public func getRadius() -> Int {
        return self.mapView.getRadius()
    }
    
    public func getCoordinate() -> CLLocationCoordinate2D {
        return self.mapView.centerCoordinate
    }
    
    public func moveMap(coordinate: CLLocationCoordinate2D) {
        self.refreshable = false
        self.mapView.setCenter(coordinate, animated: true)
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
        self.pvc?.fetchRestaurants(coordinates: self.mapView.centerCoordinate, radius: self.mapView.getRadius())
    }
    
    @IBAction func goToMyLocation(_ sender: Any) {
        self.refreshable = false
        self.refreshButton.isHidden = true
        self.pvc?.updateMyLocation()
    }
}

extension RestaurantMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapAnnotation")
        
        var markerView: MapMarkerAnnotationView?
        
        if annotationView == nil {
            annotationView = MapMarkerAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotation")
            
            markerView = annotationView as? MapMarkerAnnotationView
            
            markerView?.animatesWhenAdded = false
            markerView?.markerTintColor = Colors.themeGreen
            markerView?.glyphImage = UIImage.init(named: "marker_icon")
            markerView?.canShowCallout = true
            markerView?.titleVisibility = .hidden
            markerView?.subtitleVisibility = .hidden
        } else {
            annotationView!.annotation = annotation
            markerView = annotationView as? MapMarkerAnnotationView
        }
        
        markerView?.name = "Bala Is The Coolest"
        markerView?.numRatings = 456
        markerView?.ratings = 3.4
        markerView?.restaurantImage = UIImage.init(named: "default_image")
        
        return markerView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate ?? "default")
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        mapView.selectedMarker = marker
//        return true
//    }
//
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        let restaurant = self.restaurants[(marker.userData as? Int)!]
//        let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//
//        infoWindow.backgroundColor = .clear
//        infoWindow.restaurantName.text = restaurant.name
//        infoWindow.setNumReviews(numReviews: String(restaurant.numRatings))
//        infoWindow.setRatings(ratings: restaurant.rating)
//        //        if (restaurant.imageUrl != nil) {
//        //            infoWindow.image.imageFromURL(urlString: restaurant.imageUrl!)
//        //        }
//        infoWindow.image.image = UIImage.init(named: "default_image")
//        return infoWindow
//    }
//
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        let restaurant = self.restaurants[(marker.userData as? Int)!]
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let rmvc = storyboard.instantiateViewController(withIdentifier: "restaurantMenuVC") as! RestaurantMenuViewController
//        rmvc.restaurantName = restaurant.name!
//        rmvc.placeId = restaurant.placeId!
//        self.present(rmvc, animated: true, completion: nil)
//    }
//
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        self.noRestaurantNotice?.isHidden = true
//        if (self.refreshable) {
//            self.refreshButton.isHidden = false
//        } else {
//            self.refreshable = true
//            self.refreshButton.isHidden = true
//        }
//    }
}

extension MKMapView {

    func getTopRightCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.width, y: 0), toCoordinateFrom: self)
    }

    func getRadius() -> Int {
        let centerCoordinate = self.centerCoordinate
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopRightCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return Int(round(radius))
    }

    func getMarkersAndDisplay(restaurants: [Restaurant]) {
        self.removeAnnotations(self.annotations)
        for restaurant in restaurants {
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            self.addAnnotation(annotation)
        }
    }
}
