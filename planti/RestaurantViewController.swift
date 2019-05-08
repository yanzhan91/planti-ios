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

class RestaurantViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var optionsBlackOutView: UIView!
    @IBOutlet weak var optionScrollView: OptionsScrollView!
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    private var locationManager : CLLocationManager!
    private var restaurants: [Restaurant] = []
    private var displayingMapView: Bool = true
    
    private var refreshButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.isHidden = false
        self.listView.isHidden = true
        
        SideMenuManager.default.menuFadeStatusBar = false
        
        if (!DeviceType.hasTopNotch) {
            self.navigationBarHeight.constant = 85
        }
        
        setupPreferenceOptionBlackOutView()
        setupMapView()
        setupListView()
        setupSearchBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openMenuOption(_:)), name: NSNotification.Name("menuSelected"), object: nil)
        
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func setupMapView() {
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
        
        let x = self.view.frame.width - 50 - 20
        let y = self.mapView.frame.height - (2 * 70)
        let frame = CGRect.init(x: x, y: y, width: 50, height: 50)
        let myLocationButton = UIButton.init(frame: frame)
        myLocationButton.setImage(UIImage.init(named: "my_location_icon"), for: .normal)
        myLocationButton.addTarget(self, action: #selector(goToMyLocation), for: .touchUpInside)
        self.mapView.addSubview(myLocationButton)
        
        self.refreshButton = UIButton.init(frame: CGRect.init(x: x, y: self.mapView.frame.height - (3 * 70), width: 50, height: 50))
        self.refreshButton!.setImage(UIImage.init(named: "refresh_icon"), for: .normal)
        self.refreshButton!.addTarget(self, action: #selector(fetchRestaurants), for: .touchUpInside)
        self.mapView.addSubview(self.refreshButton!)
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    @objc private func goToMyLocation() {
        if (self.mapView.myLocation != nil) {
            locationManager.requestLocation()
        } else {
            let alert = UIAlertController(title: "Location was disabled", message: "Please go to settings and enable location permission for Planti", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    fileprivate func setupListView() {
        self.listView.delegate = self
        self.listView.dataSource = self
    }
    
    @objc private func openMenuOption(_ notification: Notification) {
        SideMenuManager.default.menuLeftNavigationController?.dismiss(animated: true, completion: nil)
        
        let frame = self.optionsBlackOutView.frame
        let x = Int((frame.width - 300) / 2)
        
        switch notification.userInfo!["menuOption"] as! Int {
        case 1:
            self.optionsBlackOutView.isHidden = true
            let pvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceViewController") as! PreferenceViewController
            self.present(pvc, animated: true, completion: nil)
            break
        case 2:
            break
        case 3:
            break
        case 4:
            self.optionsBlackOutView.isHidden = false
            let y = 100
            let width = 300
            let height = 400
            let textDialog = TextDialog.init(frame: CGRect(x: x, y: y, width: width, height: height))
            textDialog.title.text = "Terms of Service"
            textDialog.text.text = "This is a test terms of services. Bala, please complete."
            textDialog.closeButton.addTarget(self, action: #selector(blackoutTap), for: .touchUpInside)
            textDialog.closeButton.setTitle("Close", for: .normal)
            self.optionsBlackOutView.addSubview(textDialog)
            break
        case 5:
            self.optionsBlackOutView.isHidden = false
            let y = 100
            let width = 300
            let height = 400
            let textDialog = TextDialog.init(frame: CGRect(x: x, y: y, width: width, height: height))
            textDialog.title.text = "Privacy Policy"
            textDialog.text.text = "This is a test privacy policy. Bala, please complete."
            textDialog.closeButton.addTarget(self, action: #selector(blackoutTap), for: .touchUpInside)
            textDialog.closeButton.setTitle("Close", for: .normal)
            self.optionsBlackOutView.addSubview(textDialog)
            break
        case 6:
            self.optionsBlackOutView.isHidden = false
            let y = 100
            let width = 300
            let height = 273
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
        let newMenuItems = popup.newMenuItems.isOn
        let newPromotions = popup.newPromotions.isOn
        
        RestService.shared().postUser(option: nil, settings: Settings.init(newMenuItems: newMenuItems, newPromotions: newPromotions), lastKnownLocation: nil)
        
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
            let map = sender as? Dictionary<String, String>
            dest.restaurantName = (map?["restaurantName"])!
            dest.placeId = (map?["placeId"])!
            dest.option = self.optionScrollView.getPreference()
        }
    }
    
    @objc private func fetchRestaurants() {
        let coordinates = self.mapView.camera.target
        self.fetchRestaurantsWithCoordinates(coordinates: coordinates)
    }
    
    private func fetchRestaurantsWithCoordinates(coordinates: CLLocationCoordinate2D) {
        self.refreshButton?.isHidden = true
        let location = Location.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let radius = self.mapView.getRadius()
        RestService.shared().getRestaurants(option: self.optionScrollView.getPreference(), location: location, radius: Int(radius)) { restaurants in
            self.restaurants = restaurants;
            if (self.displayingMapView) {
                self.mapView.getMarkersAndDisplay(restaurants: restaurants)
            } else {
                self.listView.reloadData()
            }
            
            RestService.shared().postUser(option: self.optionScrollView.getPreference(), settings: nil, lastKnownLocation: location)
            
            DefaultsKeys.setEncodedUserDefaults(key: DefaultsKeys.LAST_KNOWN_LOCATION, value: location)
        }
    }
}

extension RestaurantViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        print("TEST UPDT: \(location.coordinate)")
        self.fetchRestaurantsWithCoordinates(coordinates: location.coordinate)
        self.mapView.animate(toLocation: location.coordinate)
        
        self.refreshButton?.isHidden = true
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension RestaurantViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let restaurant = self.restaurants[(marker.userData as? Int)!]
        let infoWindow = MapMarker.init(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        infoWindow.restaurantName.text = restaurant.name
        infoWindow.setNumReviews(numReviews: String(restaurant.numRatings))
        infoWindow.setRatings(ratings: restaurant.rating)
        if (restaurant.imageUrl != nil) {
            infoWindow.image.imageFromURL(urlString: restaurant.imageUrl!)
        }
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let restaurant = self.restaurants[(marker.userData as? Int)!]
        performSegue(withIdentifier: "openRestaurantMenu", sender: ["restaurantName": restaurant.name, "placeId": restaurant.placeId])
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.refreshButton?.isHidden = false
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
        let restaurant = self.restaurants[indexPath.row]
        performSegue(withIdentifier: "openRestaurantMenu", sender: ["restaurantName": restaurant.name, "placeId": restaurant.placeId])
    }
}

extension RestaurantViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell") as! ListViewCell
        
        let restaurant = self.restaurants[indexPath.row]
        
        if (restaurant.imageUrl != nil) {
            cell.restaurantImage.imageFromURL(urlString: restaurant.imageUrl!)
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants.count
    }
}

extension GMSMapView {
    
    func getTopRightCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topRightCoor = self.convert(CGPoint(x: self.frame.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topRightCoor)
        return point
    }
    
    func getRadius() -> Double {
        let centerCoordinate = self.camera.target
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopRightCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
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

extension RestaurantViewController : OptionsScrollViewDelegate {
    func didChangeOption(_ option: Options) {
        self.fetchRestaurants()
    }
}

extension RestaurantViewController : SearchViewControllerDelegate {
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D) {
        self.searchField.text = name
        self.mapView.animate(toLocation: coordinate)
    }
}
