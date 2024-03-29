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
    @IBOutlet weak var ratingsView: RatingsView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public func setNumReviews(numReviews: String) {
        self.ratingsView.numReviews.text = numReviews
    }
    
    public func setRatings(ratings: Float) {
        self.ratingsView.setRatings(ratings: ratings)
    }

    private func initialize() {
        Bundle.main.loadNibNamed("MapMarkerView", owner: self, options: nil)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.contentView)
    }
}
