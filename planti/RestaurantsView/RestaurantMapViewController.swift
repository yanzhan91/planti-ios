//
//  RestaurantMapViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit

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
    
    public func getUserLocation() -> CLLocationCoordinate2D {
        return self.mapView.userLocation.coordinate
    }
}

extension RestaurantMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.noRestaurantNotice?.isHidden = true
        if (self.refreshable) {
            self.refreshButton?.isHidden = false
        } else {
            self.refreshable = true
            self.refreshButton?.isHidden = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        if let cluster = annotation as? MKClusterAnnotation {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? MKMarkerAnnotationView
            if view == nil{
                view = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "cluster")
                view?.markerTintColor = Colors.themeGreen
                view?.titleVisibility = .hidden
                view?.subtitleVisibility = .hidden
            }
            return view
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapAnnotation")
        
        var markerView: MKMarkerAnnotationView?
        
        let mapAnnotation = annotation as! MapAnnotation
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotation")
            
            markerView = annotationView as? MKMarkerAnnotationView
            
            markerView?.animatesWhenAdded = false
            markerView?.markerTintColor = Colors.themeGreen
            markerView?.glyphImage = UIImage.init(named: "marker_icon")
            markerView?.canShowCallout = true
            markerView?.titleVisibility = .hidden
            markerView?.subtitleVisibility = .hidden
        } else {
            annotationView!.annotation = annotation
            markerView = annotationView as? MKMarkerAnnotationView
        }
        
        markerView?.canShowCallout = true
        
        let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 180, height: 32))
        infoWindow.backgroundColor = .clear
        infoWindow.restaurantName.text = mapAnnotation.name
        infoWindow.setNumReviews(numReviews: String(mapAnnotation.numRatings))
        infoWindow.setRatings(ratings: mapAnnotation.ratings)
        infoWindow.image.image = mapAnnotation.image
        infoWindow.selectButton.tag = mapAnnotation.index
        infoWindow.selectButton.addTarget(self, action: #selector(selectAnnotation), for: .touchUpInside)
        
        let widthConstraint = NSLayoutConstraint(item: infoWindow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180)
        infoWindow.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: infoWindow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
        infoWindow.addConstraint(heightConstraint)
        
        markerView?.detailCalloutAccessoryView = infoWindow
        
        markerView?.clusteringIdentifier = "mapAnnotation"
        
        return markerView
    }
    
    @objc func selectAnnotation(sender: UIButton) {
        let restaurant = self.restaurants[sender.tag]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rmvc = storyboard.instantiateViewController(withIdentifier: "restaurantMenuVC") as! MenuItemViewController
        rmvc.restaurantName = restaurant.restaurantName!
        rmvc.chainId = restaurant.chainId!
        rmvc.option = (self.pvc?.optionScrollView.getPreference())!
        rmvc.delegate = self.pvc
        self.present(rmvc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.annotation is MKUserLocation) {
            print("user")
        } else if (view.annotation is MKClusterAnnotation) {
            print("cluster")
            var region = MKCoordinateRegion()
            var span = MKCoordinateSpan()
            span.latitudeDelta = mapView.region.span.latitudeDelta * 0.5
            span.longitudeDelta = mapView.region.span.longitudeDelta * 0.5
            region.center = view.annotation!.coordinate
            region.span = span
            mapView.setRegion(region, animated: true)
        } else {
            mapView.setCenter(view.annotation!.coordinate, animated: true)
        }
    }
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
        for (index, restaurant) in restaurants.enumerated() {
            let annotation = MapAnnotation(index: index, name: restaurant.restaurantName!, ratings: restaurant.rating, numRatings: restaurant.numRatings, image: UIImage(named: "default_restaurant_map_image")!, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))
            self.addAnnotation(annotation)
        }
    }
}
