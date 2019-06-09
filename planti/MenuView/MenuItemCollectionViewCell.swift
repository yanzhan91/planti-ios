//
//  MenuItemCollectionViewCell.swift
//  planti
//
//  Created by Yan Zhan on 5/30/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.image.layer.cornerRadius = 10
    }
    
    func loadImage(url: URL) {
        ImageService.shared().fetchImage(urlString: url.absoluteString, defaultImage: UIImage(named: "default_menu_item_cell_image")!) { image in
            DispatchQueue.main.async {
                if (image.size.width != image.size.height) {
                    
                    let length = min(image.size.width, image.size.height)
                    let origin = CGPoint(x: (image.size.width - length)/2, y: (image.size.height - length)/2)
                    let size = CGSize(width: length, height: length)
                    
                    var rect = CGRect(origin: origin, size: size)
                    rect.origin.x *= image.scale
                    rect.origin.y*=image.scale
                    rect.size.width*=image.scale
                    rect.size.height*=image.scale
                    
                    let imageRef = image.cgImage!.cropping(to: rect)
                    self.image.image = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
                } else {
                    self.image.image = image
                }
            }
        }
    }
}
