//
//  ListViewCell.swift
//  planti
//
//  Created by Zhiyi Yang on 2/20/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var ratingsView: RatingsView!
    
    public var latitude: Double = 0
    public var longitude: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setAllTextColors() {
        self.restaurantName.textColor = Colors.themeGreen
        self.restaurantAddress.textColor = Colors.themeGreen
        self.distance.textColor = Colors.themeGreen
    }

    @IBAction func navigate(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
        } else {
            let url = "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)"
            UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
        }
    }
}
