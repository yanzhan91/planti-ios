//
//  RestaurantCollectionViewCell.swift
//  planti
//
//  Created by Yan Zhan on 5/30/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    
    public var latitude: Double = 0
    public var longitude: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    @IBAction func navigate(_ sender: Any) {
        let name = self.name.text!.replacingOccurrences(of: " ", with: "+")
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let url = "comgooglemaps://?daddr=\(name)&center=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            let url = "http://maps.apple.com/maps?daddr=\(name)&center=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image.image = image
                    }
                }
            }
        }
    }
}
