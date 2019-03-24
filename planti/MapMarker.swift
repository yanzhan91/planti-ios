//
//  MapMarker.swift
//  planti
//
//  Created by Zhiyi Yang on 3/24/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class MapMarker: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var numRatings: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("MapMarkerView", owner: self, options: nil)
        self.layer.borderColor = Colors.themeGreen.cgColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 2
        addSubview(self.contentView)
    }
}
