//
//  PostViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/23/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
//import ALCameraViewController
import TextFieldEffects
import GooglePlaces

class PostViewController: UIViewController {

    @IBOutlet weak var cameraUploadView: CameraUploadView!
    @IBOutlet weak var restaurantName: HoshiTextField!
    @IBOutlet weak var entreeName: HoshiTextField!
    @IBOutlet weak var postButton: ThemeButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meatSwitch: UISwitch!
    @IBOutlet weak var diarySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    @IBOutlet weak var fishSwitch: UISwitch!
    
    private var placeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(autocompleteTap))
        self.restaurantName.addGestureRecognizer(tap)
        
        self.postButton.activate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(cameraPresed), name: NSNotification.Name("postCamera"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.scrollView.frame)
        print(self.scrollView.contentSize)
    }
    
    private func getScrollViewContentSize(scrollView: UIScrollView) -> CGSize {
        var contentRect = CGRect.zero
        
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        contentRect.size.height += 30
        contentRect.size.width = self.view.frame.width
        
        return contentRect.size
    }
    
    @objc private func autocompleteTap() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc private func cameraPresed() {
//        let cameraViewController = CameraViewController { [weak self] image, asset in
//            // Do something with your image here.
//            self?.dismiss(animated: true, completion: nil)
//        }
//        present(cameraViewController, animated: true, completion: nil)
        print(self.scrollView.frame)
        print(self.scrollView.contentSize)
        print("Camera")
    }
    
    @IBAction func post(_ sender: Any) {
        print(self.meatSwitch.isOn)
        print(self.diarySwitch.isOn)
        print(self.eggSwitch.isOn)
        print(self.fishSwitch.isOn)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PostViewController : GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.restaurantName.text = place.name
        self.placeId = place.placeID
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
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
