//
//  RestaurantViewController.swift
//  planti
//
//  Created by Yan Zhan on 2/16/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu
import GooglePlaces

class RestaurantViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var optionsBlackOutView: UIView!
    @IBOutlet weak var optionScrollView: OptionsScrollView!
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 15.0
    private var restaurants: [Restaurant] = []
    private var displayingMapView: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.isHidden = false
        self.listView.isHidden = true
        
        SideMenuManager.default.menuFadeStatusBar = false
        
        setupPreferenceOptionBlackOutView()
        setupMapView()
        setupListView()
        setupSearchBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMneuOption(_:)), name: NSNotification.Name("menuSelected"), object: nil)
        
        self.optionScrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let preference = UserDefaults.standard.object(forKey: DefaultsKeys.PREFERENCE)
        if (preference == nil) {
            let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
            self.present(pvc, animated: true, completion: nil)
        } else {
            self.optionScrollView.setPreference(option: Options(rawValue: preference as! String)!)
        }
    }
    
    @IBAction func switchView(_ sender: Any) {
        if (self.displayingMapView) {
            self.viewButton.setImage(UIImage.init(named: "map_icon"), for: .normal)
            self.listView.reloadData()
        } else {
            self.viewButton.setImage(UIImage.init(named: "list_icon"), for: .normal)
            self.mapView.getMarkersAndDisplay(restaurants: self.restaurants)
        }
        self.mapView.isHidden = self.displayingMapView
        self.listView.isHidden = !self.displayingMapView
        self.displayingMapView = !self.displayingMapView
    }
    
    fileprivate func setupPreferenceOptionBlackOutView() {
        self.optionsBlackOutView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.optionsBlackOutView.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(blackoutTap))
        tap.delegate = self
        self.optionsBlackOutView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupSearchBar() {
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
    }
    
    @objc private func search() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    fileprivate func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 41.8823, longitude: -87.6404, zoom: zoomLevel)
        self.mapView.camera = camera
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = false
        self.mapView.settings.myLocationButton = false
        self.mapView.settings.zoomGestures = true
        self.mapView.settings.tiltGestures = false
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.indoorPicker = false
        
        let x = self.view.frame.width - 64 - 15
        let y = self.view.frame.height - (168 + self.mapView.frame.origin.y)
        let frame = CGRect.init(x: x, y: y, width: 64, height: 64)
        let myLocationButton = UIButton.init(frame: frame)
        
        myLocationButton.setImage(UIImage.init(named: "my_location_icon"), for: .normal)
        myLocationButton.addTarget(self, action: #selector(goToMyLocation), for: .touchUpInside)
        self.mapView.addSubview(myLocationButton)
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    @objc private func goToMyLocation() {
        if (self.mapView.myLocation != nil) {
            self.mapView.animate(toLocation: (self.mapView.myLocation?.coordinate)!)
        }
    }
    
    fileprivate func setupListView() {
        self.listView.delegate = self
        self.listView.dataSource = self
    }
    
    @objc private func openMneuOption(_ notification: Notification) {
        self.optionsBlackOutView.isHidden = false
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        
        let frame = self.optionsBlackOutView.frame
        let x = Int((frame.width - 300) / 2)
        
        switch notification.userInfo!["menuOption"] as! Int {
        case 1:
            self.optionsBlackOutView.isHidden = true
            let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
            self.present(pvc, animated: true, completion: nil)
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            let y = 100
            let width = 300
            let height = 570
            let textDialog = TextDialog.init(frame: CGRect(x: x, y: y, width: width, height: height))
            textDialog.title.text = "Terms of Service"
            textDialog.text.text = "This is a test terms of services. Bala, please complete."
            textDialog.closeButton.addTarget(self, action: #selector(blackoutTap), for: .touchUpInside)
            textDialog.closeButton.setTitle("Close", for: .normal)
            self.optionsBlackOutView.addSubview(textDialog)
            break
        case 5:
            let y = 100
            let width = 300
            let height = 570
            let textDialog = TextDialog.init(frame: CGRect(x: x, y: y, width: width, height: height))
            textDialog.title.text = "Privacy Policy"
            textDialog.text.text = "This is a test privacy policy. Bala, please complete."
            textDialog.closeButton.addTarget(self, action: #selector(blackoutTap), for: .touchUpInside)
            textDialog.closeButton.setTitle("Close", for: .normal)
            self.optionsBlackOutView.addSubview(textDialog)
            break
        case 6:
            let y = 100
            let width = 300
            let height = 570
            let settingsDialog = SettingsDialog.init(frame: CGRect(x: x, y: y, width: width, height: height))
            settingsDialog.saveButton.addTarget(self, action: #selector(changeSettings(_:)), for: .touchUpInside)
            self.optionsBlackOutView.addSubview(settingsDialog)
            break
        default:
            break;
        }
    }
    
    @objc private func changeSettings(_ button: ThemeButton) {
        let popup = button.superview?.superview as! SettingsDialog
        print(popup.newMenuItems.isOn)
        print(popup.newPromotions.isOn)
        blackoutTap()
    }
    
    @objc private func blackoutTap() {
        self.optionsBlackOutView.isHidden = true
        for subview in self.optionsBlackOutView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is RestaurantMenuViewController) {
            let dest = segue.destination as! RestaurantMenuViewController
            print("\(sender is UITableView)")
            print("\(sender is String)")
            dest.restaurantName = sender as! String
            dest.option = self.optionScrollView.getPreference()
        }
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
        
        Database.shared().getRestaurants(option: self.optionScrollView.getPreference()) { restaurants in
            self.mapView.getMarkersAndDisplay(restaurants: restaurants)
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let restaurant = marker.userData as? Restaurant
        let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        infoWindow.restaurantName.text = restaurant?.name
        infoWindow.setNumReviews(numReviews: String(restaurant?.numRatings ?? 0))
        infoWindow.setRatings(ratings: restaurant?.ratings ?? 0)
        return infoWindow
    }
}

extension RestaurantViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (self.optionsBlackOutView.subviews.count == 0) {
            return true;
        }
        return !touch.view!.isDescendant(of: self.optionsBlackOutView.subviews[0])
    }
}

extension RestaurantViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ListViewCell
        performSegue(withIdentifier: "openRestaurantMenu", sender: cell.restaurantName.text)
    }
}

extension RestaurantViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as! ListViewCell
        cell.restaurantImage.imageFromURL(urlString: "https://images.sftcdn.net/images/t_app-logo-l,f_auto,dpr_auto/p/a00b5514-9b26-11e6-8ccf-00163ec9f5fa/4091407790/restaurant-story-logo.png")
        cell.restaurantName.text = "Test Restaurant"
        cell.restaurantAddress.text = "500 W. Madison St, Chicago, IL 60661"
        cell.distance.text = "8.4 Miles"
        
        cell.ratingsView.setRatings(ratings: 4.3)
        cell.ratingsView.numReviews.text = "108"
        
        cell.setAllTextColors()
        cell.latitude = 41.8823
        cell.longitude = -87.6404
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
    
    func getMarkersAndDisplay(restaurants: [Restaurant]) {
        self.clear()
        for restaurant in restaurants {
            let marker = GMSMarker()
            marker.userData = restaurant
            marker.position = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            marker.map = self
        }
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

extension RestaurantViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.searchField.text = place.name
        
        dismiss(animated: true) {
            self.mapView.animate(toLocation: place.coordinate)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension RestaurantViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        Database.shared().getRestaurants(option: self.optionScrollView.getPreference()) { restaurants in
            self.restaurants = restaurants;
            if (self.displayingMapView) {
                self.mapView.getMarkersAndDisplay(restaurants: restaurants)
            } else {
                 self.listView.reloadData()
            }
        }
    }
}
