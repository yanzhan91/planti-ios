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

class RestaurantParentViewController: UIViewController {
    
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
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    
    private var locationManager : CLLocationManager!
    private var location: CLLocationCoordinate2D?
    private var radius: Int?
    
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
        if (UserDefaults.standard.object(forKey: DefaultsKeys.PREFERENCE) == nil) {
            let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
            pvc.delegate = self
            self.present(pvc, animated: true, completion: nil)
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
            switchView(AnyObject.self)
        }
    }
    
    @objc private func search() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is RestaurantMenuViewController) {
            let dest = segue.destination as! RestaurantMenuViewController
            let map = sender as? Dictionary<String, String>
            dest.restaurantName = (map?["restaurantName"])!
            dest.placeId = (map?["placeId"])!
            dest.option = self.optionScrollView.getPreference()
        }
    }
    
    public func fetchRestaurants(coordinates: CLLocationCoordinate2D, radius: Int) {
        RestService.shared().getRestaurants(option: self.optionScrollView.getPreference(), location: coordinates, radius: Int(radius)) { restaurants in

            self.restaurants = restaurants
            self.mapViewController.reload(restaurants: restaurants)

//            RestService.shared().postUser(option: self.optionScrollView.getPreference(), settings: nil, lastKnownLocation: coordinates)

//            DefaultsKeys.setEncodedUserDefaults(key: DefaultsKeys.LAST_KNOWN_LOCATION_LATITUDE, value: coordinates.latitude)
//            DefaultsKeys.setEncodedUserDefaults(key: DefaultsKeys.LAST_KNOWN_LOCATION_LONGITUDE, value: coordinates.longitude)
        }
    }
    
    public func updateMyLocation() {
        locationManager.requestLocation()
    }
}

extension RestaurantParentViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        self.fetchRestaurants(coordinates: self.mapViewController.getCoordinate(), radius: self.mapViewController.getRadius())
    }
}

extension RestaurantParentViewController : SearchViewControllerDelegate {
    func selectingSearchResult() {
        self.switchView(vc: self.mapViewController)
    }
    
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D) {
        self.searchField.text = name
        self.mapViewController.moveMap(coordinate: coordinate)
        self.fetchRestaurants(coordinates: coordinate, radius: self.mapViewController.getRadius())
    }
}

extension RestaurantParentViewController : PreferenceViewControllerDelegate {
    func optionDidChange(option: Options) {
        self.optionScrollView.setPreference(option: option)
                UserDefaults.standard.set(option.rawValue, forKey: DefaultsKeys.PREFERENCE)
        self.fetchRestaurants(coordinates: self.mapViewController.getCoordinate(), radius: self.mapViewController.getRadius())
    }
}

extension RestaurantParentViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        switchView(vc: self.mapViewController)
        self.mapViewController.moveMap(coordinate: location.coordinate)
        self.fetchRestaurants(coordinates: location.coordinate, radius: self.mapViewController.getRadius())
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
