//
//  MenuImageViewController.swift
//  planti
//
//  Created by Yan Zhan on 6/1/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import ImageSlideshow

class MenuImageViewController: UIViewController {
    
    public var menuItems: [MenuItem]?
    public var index: Int = 0
    @IBOutlet weak var slideView: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideView.slideshowInterval = 0
        slideView.circular = false
        slideView.activityIndicator = DefaultActivityIndicator()
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = Colors.themeGreen
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        slideView.pageIndicator = pageIndicator
        
        let images: [AlamofireSource] = (self.menuItems?.map { AlamofireSource(urlString: $0.imageUrl!)! }) ?? []
        slideView.setImageInputs(images)
        
        slideView.presentFullScreenController(from: self)
    }
    
    func loadImage(url: URL) -> UIImage {
        var result: UIImage?
        DispatchQueue.global().async { () in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
                        result = image
//                    }
                }
            }
        }
        return result ?? UIImage(named: "default_image")!
    }
}
