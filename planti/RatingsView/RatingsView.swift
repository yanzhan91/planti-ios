//
//  RatingsView.swift
//  planti
//
//  Created by Zhiyi Yang on 3/25/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit

class RatingsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var numReviews: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("RatingsView", owner: self, options: nil)
        self.numReviews.textColor = Colors.themeGreen
        addSubview(self.contentView)
    }
    
    public func setRatings(ratings: Float) {
        let rounded = ratings.rounded(.down)
        self.star1.image = UIImage.init(named: rounded >= 1 ? "full_star_icon" : "empty_star_icon")
        self.star2.image = UIImage.init(named: rounded >= 2 ? "full_star_icon" : "empty_star_icon")
        self.star3.image = UIImage.init(named: rounded >= 3 ? "full_star_icon" : "empty_star_icon")
        self.star4.image = UIImage.init(named: rounded >= 4 ? "full_star_icon" : "empty_star_icon")
        self.star5.image = UIImage.init(named: rounded >= 5 ? "full_star_icon" : "empty_star_icon")
    }
}
