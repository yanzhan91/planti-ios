//
//  MenuImageViewController.swift
//  planti
//
//  Created by Yan Zhan on 6/1/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import ImageSlideshow

class MenuImageViewController: UIViewController, ImageSlideshowDelegate {
    
    public var menuItems: [MenuItem]?
    public var index: Int = 0
    @IBOutlet weak var slideView: ImageSlideshow!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var containsText: UILabel!
    @IBOutlet weak var postedText: UILabel!
    
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
            if ($0.imageUrl == nil) {
                return AlamofireSource(urlString: $0.imageUrl!)!
            } else {
                return ImageSource(image: UIImage(named: "default_menu_item_full_image")!)
            }
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
    }
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        setMenuTexts(index: page)
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
}
