//
//  PostViewController.swift
//  planti
//
//  Created by Zhiyi Yang on 2/23/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import TextFieldEffects
import MapKit
import AVFoundation
import NVActivityIndicatorView

class PostViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var restaurantName: HoshiTextField!
    @IBOutlet weak var entreeName: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var postButton: ThemeButton!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meatSwitch: UISwitch!
    @IBOutlet weak var diarySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    
    var coordinate: CLLocationCoordinate2D?
    var name: String?
    var uploadImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.name == nil) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(autocompleteTap))
            self.restaurantName.addGestureRecognizer(tap)
        } else {
            self.restaurantName.text = name
            self.restaurantName.isEnabled = false
        }
        
        self.postButton.activate()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        swipeDownGesture.direction = .down
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        swipeUpGesture.direction = .up
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
        self.view.addGestureRecognizer(swipeUpGesture)
        
        self.cameraView.image = UIImage(named: "camera_icon")?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
        self.cameraView.isUserInteractionEnabled = true
        let cameraGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTap))
        self.cameraView.addGestureRecognizer(cameraGesture)
        self.cameraView.layer.cornerRadius = 12
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = getScrollViewContentSize(scrollView: self.scrollView)
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.entreeName.resignFirstResponder()
        self.email.resignFirstResponder()
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
    
    @IBAction func post(_ sender: Any) {
        if ((self.restaurantName.text ?? "").isEmpty || (self.entreeName.text ?? "").isEmpty) {
            let okAlert = AlertService.shared().createOkAlert(title: "Error", message: "Please enter restaurant name and item", buttonTitle: "OK", viewController: self)
            self.present(okAlert, animated: true)
        } else {
            self.startAnimating()
            let image = uploadImage ? self.cameraView.image : nil
            uploadImage = false
            RestService.shared().postMenuItem(restaurantName: self.restaurantName.text ?? "", menuItemName: self.entreeName.text ?? "", email: self.email.text, containsMeat: self.meatSwitch.isOn, containsDiary: self.diarySwitch.isOn, containsEgg: self.eggSwitch.isOn, image: image) { () in
                
                self.stopAnimating()
                let okAlert = AlertService.shared().createOkAlert(title: "Thank you!", message: "To maintain accuracy, your posting will be verified before being displayed to all Planti users.", buttonTitle: "OK", viewController: self) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(okAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cameraTap() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.cameraFlashMode = .auto
            present(vc, animated: true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { response in
                let vc = UIImagePickerController()
                vc.sourceType = .camera
                vc.delegate = self
                vc.cameraFlashMode = .auto
                self.present(vc, animated: true)
            }
            break
        case .restricted, .denied:
            let alert = AlertService.shared().createActionAlert(title: "Camera Permission Required", message: "Allow Planti to access your phone camera to post menu item photos.", buttonType: .SETTINGS, viewController: self)
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}

extension PostViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        print(image.size)
        self.cameraView.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.uploadImage = true
    }
}

extension PostViewController : UINavigationControllerDelegate {
    
}

extension PostViewController : SearchViewControllerDelegate {
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D) {
        self.restaurantName.text = name
        self.coordinate = coordinate
    }
}
