//
//  RestaurantParentViewController.swift
//  planti
//
//  Created by Yan Zhan on 5/12/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import SideMenu
import MapKit
import NVActivityIndicatorView

class RestaurantParentViewController: UIViewController, NVActivityIndicatorViewable {
    
    private lazy var mapViewController: RestaurantMapViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "RestaurantMapViewController") as! RestaurantMapViewController
        
        return viewController
    }()
    
    private lazy var listViewController: RestaurantCollectionViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "RestaurantCollectionViewController") as! RestaurantCollectionViewController

        return viewController
    }()
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var optionScrollView: OptionsScrollView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var switchViewButton: UIButton!
    
    private var locationManager : CLLocationManager!
    private var location: CLLocationCoordinate2D?
    
    private var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideMenuManager.default.menuFadeStatusBar = false
        
        self.optionScrollView.delegate = self
        
        let searchButton = UIButton.init(type: .custom)
        searchButton.setImage(UIImage(named: "search_icon"), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 21, height: 16)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.searchField.leftView = searchButton
        self.searchField.leftViewMode = .always
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(search))
        tap.numberOfTapsRequired = 1
        self.searchField.addGestureRecognizer(tap)
        self.searchField.isUserInteractionEnabled = true
        
        self.activeViewController = self.mapViewController
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: DefaultsKeys.PREFERENCE) == nil) {
            let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
            pvc.delegate = self
            self.present(pvc, animated: true, completion: nil)
        } else {
            let option = Options(rawValue: UserDefaults.standard.string(forKey: DefaultsKeys.PREFERENCE)!) ?? .vegan
            if (optionScrollView.getPreference() != option) {
                self.optionScrollView.setPreference(option: option)
            }
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParent: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParent()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChild(activeVC)
            
            activeVC.view.frame = contentView.bounds
            contentView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMove(toParent: self)
        }
    }
    
    @IBAction func switchView(_ sender: Any) {
        let button = sender as! UIButton
        if (self.activeViewController == self.mapViewController) {
            button.setImage(UIImage.init(named: "map_icon"), for: .normal)
            activeViewController = self.listViewController
            self.listViewController.reload(restaurants: self.restaurants)
        } else {
            button.setImage(UIImage.init(named: "list_icon"), for: .normal)
            activeViewController = self.mapViewController
        }
    }
    
    private func switchView(vc: UIViewController) {
        if (activeViewController != vc) {
            switchView(self.switchViewButton!)
        }
    }
    
    @objc private func search() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is MenuItemViewController) {
            let dest = segue.destination as! MenuItemViewController
            let map = sender as? Dictionary<String, String>
            dest.restaurantName = (map?["restaurantName"])!
            dest.chainId = (map?["chainId"])!
            dest.option = self.optionScrollView.getPreference()
        }
    }
    
    public func fetchRestaurants(coordinates: CLLocationCoordinate2D) {
        let (minLat, minLng, maxLat, maxLng) = self.mapViewController.getCoordinateRangesWithCenterCoordinate(center: coordinates)
        fetchRestaurants(coordinates: coordinates, minLat: minLat, minLng: minLng, maxLat: maxLat, maxLng: maxLng)
    }
    
    public func fetchRestaurants(coordinates: CLLocationCoordinate2D, region: MKCoordinateRegion) {
        let (minLat, minLng, maxLat, maxLng) = self.mapViewController.getCoordinateRangesWithCenterCoordinate(center: coordinates, region: region)
        fetchRestaurants(coordinates: coordinates, minLat: minLat, minLng: minLng, maxLat: maxLat, maxLng: maxLng)
    }
    
    public func fetchRestaurants(coordinates: CLLocationCoordinate2D, minLat: Double, minLng: Double, maxLat: Double, maxLng: Double) {
        if !self.isAnimating {
            self.startAnimating()
            RestService.shared().getRestaurants(option: self.optionScrollView.getPreference(), minLat: minLat, minLng: minLng, maxLat: maxLat, maxLng: maxLng, userLocation: self.mapViewController.getUserLocation()) { restaurants in
                
                if (restaurants == nil) {
                    let alert = AlertService.shared().createOkAlert(title: "Error", message: "Unable to connect. Check your internet connection and try again.", buttonTitle: "Retry", viewController: self) { _ in
                        self.fetchRestaurants(coordinates: coordinates, minLat: minLat, minLng: minLng, maxLat: maxLat, maxLng: maxLng)
                    }
                    self.present(alert, animated: true)
                    self.stopAnimating()
                    return
                }
                
                self.restaurants = restaurants!
                self.mapViewController.reload(restaurants: restaurants!)
                self.listViewController.reload(restaurants: restaurants!)
                
                self.stopAnimating()
            }
        }
    }
    
    public func updateMyLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            clearSearchField()
            locationManager.requestLocation()
        } else {
            let alert = AlertService.shared().createSettingsAlert(title: "Location Service Is Disabled", message: "To enable, click Settings and turn on location service for this app.", buttonTitle: "Settings", viewController: self)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func clearSearchField() {
        self.searchField.text = ""
    }
}

extension RestaurantParentViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        self.fetchRestaurants(coordinates: self.mapViewController.getCoordinate())
    }
}

extension RestaurantParentViewController : SearchViewControllerDelegate {
    func selectingSearchResult() {
        self.switchView(vc: self.mapViewController)
    }
    
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D) {
        self.searchField.text = name
        let region: MKCoordinateRegion = self.mapViewController.moveMap(coordinate: coordinate)
        self.fetchRestaurants(coordinates: coordinate, region: region)
    }
}

extension RestaurantParentViewController : PreferenceViewControllerDelegate {
    func optionDidChange(option: Options) {
        if option != self.optionScrollView.getPreference() {
            self.optionScrollView.setPreference(option: option)
        }
    }
}

extension RestaurantParentViewController :  MenuItemViewControllerDelegate {
    func optionDidChangeInMenuItem(option: Options) {
        if option != self.optionScrollView.getPreference() {
            self.optionScrollView.setPreference(option: option)
        }
    }
}

extension RestaurantParentViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        if (location.coordinate.latitude != 0 && location.coordinate.longitude != 0) {
            switchView(vc: self.mapViewController)
            let region = self.mapViewController.moveMap(coordinate: location.coordinate)
            self.fetchRestaurants(coordinates: location.coordinate, region: region)
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        self.fetchRestaurants(coordinates: CLLocationCoordinate2D(latitude: 41.8823, longitude: -87.6404))
    }
}
