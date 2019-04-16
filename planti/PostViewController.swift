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
    @IBOutlet weak var navigationBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meatSwitch: UISwitch!
    @IBOutlet weak var diarySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    
    var placeId: String?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.name == nil) {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(autocompleteTap))
            self.restaurantName.addGestureRecognizer(tap)
        } else {
            self.restaurantName.text = name
            self.restaurantName.isEnabled = false
        }
        
        self.postButton.activate()
        
        if (!DeviceType.hasTopNotch) {
            self.navigationBarHeight.constant = 85
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cameraPresed), name: NSNotification.Name("postCamera"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.entreeName.resignFirstResponder()
    }
    
    private func getScrollViewContentSize(scrollView: UIScrollView) -> CGSize {
        var contentRect = CGRect.zero
        
        print(scrollView.subviews.count)
        
        for view in scrollView.subviews {
            print(view.frame)
            contentRect = contentRect.union(view.frame)
        }
        
        contentRect.size.width = self.view.frame.width
        
        print(contentRect.size)
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
        RestService.shared().postMenuItem(placeId: self.placeId ?? "", restaurantName: self.restaurantName.text ?? "", menuItemName: self.entreeName.text ?? "", containsMeat: self.meatSwitch.isOn, containsDiary: self.diarySwitch.isOn, containsEgg: self.eggSwitch.isOn) { () in
            
            let okAlert = UIAlertController(title: "Thank you!", message: "Your contribution will benefit millions of others.", preferredStyle: .alert)
            okAlert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            })
            self.present(okAlert, animated: true, completion: nil)
        }
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
