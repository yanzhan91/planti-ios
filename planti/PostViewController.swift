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
import MapKit

class PostViewController: UIViewController {

    @IBOutlet weak var cameraUploadView: UIView!
    @IBOutlet weak var restaurantName: HoshiTextField!
    @IBOutlet weak var entreeName: HoshiTextField!
    @IBOutlet weak var postButton: ThemeButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meatSwitch: UISwitch!
    @IBOutlet weak var diarySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    
    var coordinate: CLLocationCoordinate2D?
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(cameraPresed), name: NSNotification.Name("postCamera"), object: nil)
        
        self.cameraUploadView.layer.borderWidth = 1.0
        self.cameraUploadView.layer.borderColor = Colors.themeGreen.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.entreeName.resignFirstResponder()
    }
    
    private func getScrollViewContentSize(scrollView: UIScrollView) -> CGSize {
        var contentRect = CGRect.zero
        
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        contentRect.size.width = self.view.frame.width
        
        return contentRect.size
    }
    
    @objc private func autocompleteTap() {
        let searchVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVc.delegate = self
        self.present(searchVc, animated: true, completion: nil)
    }
    
    @objc private func cameraPresed() {
//        let cameraViewController = CameraViewController { [weak self] image, asset in
//            // Do something with your image here.
//            self?.dismiss(animated: true, completion: nil)
//        }
//        present(cameraViewController, animated: true, completion: nil)
//        print(self.scrollView.frame)
//        print(self.scrollView.contentSize)
        print("Camera")
    }
    
    @IBAction func post(_ sender: Any) {
        RestService.shared().postMenuItem(name: self.name ?? "", menuItemName: self.entreeName.text ?? "", containsMeat: self.meatSwitch.isOn, containsDiary: self.diarySwitch.isOn, containsEgg: self.eggSwitch.isOn) { () in
            
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
    
    @IBAction func turnOnCamera(_ sender: Any) {
        
    }
}

extension PostViewController : SearchViewControllerDelegate {
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D) {
        self.restaurantName.text = name
        self.coordinate = coordinate
    }
}
