//
//  MenuImageViewController.swift
//  planti
//
//  Created by Yan Zhan on 6/1/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVFoundation

class MenuImageViewController: UIViewController, ImageSlideshowDelegate {
    
    public var menuItems: [MenuItem]?
    public var index: Int = 0
    @IBOutlet weak var slideView: ImageSlideshow!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var containsText: UILabel!
    @IBOutlet weak var postedText: UILabel!
    @IBOutlet weak var addPhotoView: UIView!
    
    public var isDefaultImages: [Int:Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slideView.slideshowInterval = 0
        self.slideView.circular = false
        self.slideView.activityIndicator = DefaultActivityIndicator()
        self.slideView.contentScaleMode = .scaleAspectFit
        self.slideView.zoomEnabled = true
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = Colors.themeGreen
        pageIndicator.pageIndicatorTintColor = .white
        pageIndicator.isUserInteractionEnabled = false
        self.slideView.pageIndicator = pageIndicator
        self.slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        
        let images: [InputSource] = (self.menuItems?.map {
            return AlamofireSource(urlString: $0.getImageUrl(), placeholder: UIImage(named: "default_menu_item_full_image"))!
        }) ?? []
        self.slideView.setImageInputs(images)
        
        self.slideView.backgroundColor = .black
        self.slideView.delegate = self
        self.slideView.preload = .fixed(offset: 5)
        
        if (self.index == 0) {
            setMenuTexts(index: self.index)
        } else {
            self.slideView.setCurrentPage(self.index, animated: false)
        }
        
        self.addPhotoView.isHidden = !(self.isDefaultImages[self.index] ?? true)
    }
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        setMenuTexts(index: page)
        self.addPhotoView.isHidden = !(self.isDefaultImages[page] ?? false)
    }
    
    func setMenuTexts(index: Int) {
        let item = self.menuItems?[index]
        self.menuName.text = item?.menuItemName
        self.containsText.text = item?.containsLabel
        self.postedText.text = item?.postedBy

    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
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

extension MenuImageViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            let alert = AlertService.shared().createOkAlert(title: "There was an error", message: "Please try again later", buttonTitle: "OK", viewController: self)
            self.present(alert, animated: true)
            return
        }
        
        if (self.menuItems != nil && self.menuItems!.count > self.slideView.currentPage) {
            let id = self.menuItems![self.slideView.currentPage].id
            RestService.shared().postMenuItemImage(id: id, image: image) { success in
                if (success) {
                    let alert = AlertService.shared().createOkAlert(title: "Success", message: "Thank you for your contribution. To help protect other users, your image will be displayed after our review process.", buttonTitle: "OK", viewController: self)
                    self.present(alert, animated: true)
                    return
                } else {
                    let alert = AlertService.shared().createOkAlert(title: "There was an error", message: "Please try again later", buttonTitle: "OK", viewController: self)
                    self.present(alert, animated: true)
                    return
                }
            }
        }
    }
}

extension MenuImageViewController : UINavigationControllerDelegate {
}
