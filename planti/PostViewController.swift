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

    @IBOutlet weak var restaurantName: HoshiTextField!
    @IBOutlet weak var entreeName: HoshiTextField!
    @IBOutlet weak var postButton: ThemeButton!
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var meatSwitch: UISwitch!
    @IBOutlet weak var diarySwitch: UISwitch!
    @IBOutlet weak var eggSwitch: UISwitch!
    
    var coordinate: CLLocationCoordinate2D?
    var name: String?
    
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
        let swipGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        swipGesture.direction = .down
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(swipGesture)
        
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
        RestService.shared().postMenuItem(name: self.restaurantName.text ?? "", menuItemName: self.entreeName.text ?? "", containsMeat: self.meatSwitch.isOn, containsDiary: self.diarySwitch.isOn, containsEgg: self.eggSwitch.isOn) { () in
            
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
    
    @objc func cameraTap() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
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
