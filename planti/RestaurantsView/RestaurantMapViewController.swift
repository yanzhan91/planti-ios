//
//  RestaurantMapViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit
import Cluster

class RestaurantMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.region = .init(center: region.center, span: .init(latitudeDelta: region.delta, longitudeDelta: region.delta))
        }
    }
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    lazy var manager: ClusterManager = { [unowned self] in
        let manager = ClusterManager()
        manager.delegate = self
        manager.maxZoomLevel = 20
        manager.minCountForClustering = 2
        manager.clusterPosition = .nearCenter
        manager.shouldRemoveInvisibleAnnotations = true
        return manager
    }()
    
    let region = (center: CLLocationCoordinate2D(latitude: 41.8823, longitude: -87.6404), delta: 0.01)
    
    private var restaurants: [Restaurant] = []
    
    private var pvc: RestaurantParentViewController?
    private var refreshable = true
    
    private var noRestaurantNotice: ThemeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.mapType = .mutedStandard
    
        self.mapView.delegate = self
        self.mapView.isRotateEnabled = false
        self.mapView.showsUserLocation = true
        self.mapView.isPitchEnabled = false
        self.mapView.showsBuildings = false
        self.mapView.showsTraffic = false
        self.mapView.showsPointsOfInterest = false
        self.mapView.userTrackingMode = .none
        
        self.refreshButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pvc = self.parent as? RestaurantParentViewController
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
            self.getMarkersAndDisplay(restaurants: restaurants)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
//        print(manager.zoomLevel)
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
    
    func getMarkersAndDisplay(restaurants: [Restaurant]) {
        var annotations: [MapAnnotation] = []
        for (index, restaurant) in restaurants.enumerated() {
            let annotation = MapAnnotation(index: index, name: restaurant.restaurantName!, ratings: restaurant.rating, numRatings: restaurant.numRatings, image: UIImage(named: "default_restaurant_map_image")!, coordinate: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))
            //            self.addAnnotation(annotation)
            annotations.append(annotation)
        }
        self.manager.removeAll()
        self.manager.add(annotations)
        self.manager.reload(mapView: self.mapView)
    }
}

extension RestaurantMapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if zoomRect.isNull {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
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
        if annotation is MKUserLocation {
            mapView.view(for: annotation)?.isEnabled = false
            return nil
        } else if let annotation = annotation as? ClusterAnnotation {
            return mapView.annotationView(annotation: annotation, reuseIdentifier: "clusterIdentifier")
        } else {
            let annotation = annotation as! MapAnnotation
            let annotationView = mapView.annotationView(of: MKPinAnnotationView.self, annotation: annotation, reuseIdentifier: "mapIdentifier")
            
//            annotationView.animatesWhenAdded = false
//            annotationView.markerTintColor = Colors.themeGreen
//            annotationView.glyphImage = UIImage.init(named: "marker_icon")
//            annotationView.canShowCallout = true
//            annotationView.titleVisibility = .hidden
//            annotationView.subtitleVisibility = .hidden
            
            annotationView.canShowCallout = true
            annotationView.pinTintColor = Colors.themeGreen
            annotationView.animatesDrop = true
            
            let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 180, height: 32))
            infoWindow.backgroundColor = .clear
            infoWindow.restaurantName.text = annotation.name
            infoWindow.setNumReviews(numReviews: String(annotation.numRatings))
            infoWindow.setRatings(ratings: annotation.ratings)
            infoWindow.image.image = annotation.image
            infoWindow.selectButton.tag = annotation.index
            infoWindow.selectButton.addTarget(self, action: #selector(selectAnnotation), for: .touchUpInside)

            let widthConstraint = NSLayoutConstraint(item: infoWindow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 180)
            infoWindow.addConstraint(widthConstraint)

            let heightConstraint = NSLayoutConstraint(item: infoWindow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32)
            infoWindow.addConstraint(heightConstraint)

            annotationView.detailCalloutAccessoryView = infoWindow
            
            return annotationView
        }
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
}

extension RestaurantMapViewController: ClusterManagerDelegate {
    func cellSize(for zoomLevel: Double) -> Double? {
        return nil // default
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return !(annotation is MKUserLocation)
    }
}

extension MKMapView {
    func annotationView(annotation: MKAnnotation?, reuseIdentifier: String) -> MKAnnotationView {
        let annotationView = self.annotationView(of: MapClusterAnnotationView.self, annotation: annotation, reuseIdentifier: reuseIdentifier)
        annotationView.countLabel.backgroundColor = Colors.themeGreen
        return annotationView
    }
    
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
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
}
